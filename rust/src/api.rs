use flutter_rust_bridge::frb;
use std::{collections::HashMap, str::FromStr};
use taskchampion::{
    chrono::{DateTime, Utc},
    Operations, Tag, ServerConfig,
};
use uuid::Uuid;

use crate::serialize::task_to_json;
use crate::storage::open_replica;
use crate::utils::error::TcHelperError;

fn parse_datetime(input: &str) -> Option<DateTime<Utc>> {
    if input.trim().is_empty() {
        return None;
    }
    input.parse::<DateTime<Utc>>().ok()
}

/// Return every task in the replica as a JSON array string.
#[frb]
pub fn get_all_tasks_json(taskdb_dir_path: String) -> Result<String, String> {
    get_all_tasks_json_impl(&taskdb_dir_path).map_err(|e| e.to_string())
}

fn get_all_tasks_json_impl(taskdb_dir_path: &str) -> Result<String, TcHelperError> {
    let mut replica = open_replica(taskdb_dir_path)?;
    let tasks = replica
        .all_tasks()
        .map_err(|e| TcHelperError::Champion(e.to_string()))?;

    let json_tasks: Vec<serde_json::Value> = tasks.values().map(task_to_json).collect();
    Ok(serde_json::to_string(&json_tasks)?)
}

/// Delete the task with the given UUID. A no-op if the task does not exist.
#[frb]
pub fn delete_task(uuid_st: String, taskdb_dir_path: String) -> Result<(), String> {
    delete_task_impl(&uuid_st, &taskdb_dir_path).map_err(|e| e.to_string())
}

fn delete_task_impl(uuid_st: &str, taskdb_dir_path: &str) -> Result<(), TcHelperError> {
    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();
    let uuid = Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;

    if let Some(mut t) = replica
        .get_task_data(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
    {
        t.delete(&mut ops);
    }
    replica
        .commit_operations(ops)
        .map_err(|e| TcHelperError::Commit(e.to_string()))?;
    Ok(())
}

/// Update the mutable fields of an existing task from the supplied key/value map.
#[frb]
pub fn update_task(
    uuid_st: String,
    taskdb_dir_path: String,
    map: HashMap<String, String>,
) -> Result<(), String> {
    update_task_impl(&uuid_st, &taskdb_dir_path, map).map_err(|e| e.to_string())
}

#[allow(deprecated)] // `get_taskmap` is deprecated upstream; used to enumerate existing tags.
fn update_task_impl(
    uuid_st: &str,
    taskdb_dir_path: &str,
    map: HashMap<String, String>,
) -> Result<(), TcHelperError> {
    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();
    let uuid = Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;

    if let Some(mut t) = replica
        .get_task(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
    {
        let _ = t.set_status(taskchampion::Status::Pending, &mut ops);
        for (key, value) in map {
            match key.as_str() {
                "description" => {
                    let _ = t.set_description(value, &mut ops);
                }
                "due" => {
                    let _ = t.set_due(parse_datetime(&value), &mut ops);
                }
                "start" => {
                    if value == "stop" {
                        let _ = t.stop(&mut ops);
                    } else {
                        let _ = t.start(&mut ops);
                    }
                }
                "wait" => {
                    let _ = t.set_wait(parse_datetime(&value), &mut ops);
                }
                "priority" => {
                    let _ = t.set_priority(value, &mut ops);
                }
                "tags" => {
                    let existing_tags: Vec<String> = t
                        .get_taskmap()
                        .iter()
                        .filter_map(|(k, _)| k.strip_prefix("tag_").map(|s| s.to_string()))
                        .collect();
                    for tag_name in existing_tags {
                        if let Ok(mut tag) = Tag::from_str(&tag_name) {
                            let _ = t.remove_tag(&mut tag, &mut ops);
                        }
                    }
                    for part in value.split_whitespace() {
                        if let Ok(mut tag) = Tag::from_str(part) {
                            let _ = t.add_tag(&mut tag, &mut ops);
                        }
                    }
                }
                "project" => {
                    let _ = t.set_value("project", Some(value), &mut ops);
                }
                "status" => {
                    let status = match value.as_str() {
                        "pending" => taskchampion::Status::Pending,
                        "completed" => taskchampion::Status::Completed,
                        "deleted" => taskchampion::Status::Deleted,
                        _ => taskchampion::Status::Pending,
                    };
                    let _ = t.set_status(status, &mut ops);
                }
                _ => {}
            }
        }
        replica
            .commit_operations(ops)
            .map_err(|e| TcHelperError::Commit(e.to_string()))?;
    }
    Ok(())
}

/// Create a new task from the supplied key/value map. The map must contain a
/// `uuid` entry.
#[frb]
pub fn add_task(taskdb_dir_path: String, map: HashMap<String, String>) -> Result<(), String> {
    add_task_impl(&taskdb_dir_path, map).map_err(|e| e.to_string())
}

fn add_task_impl(taskdb_dir_path: &str, map: HashMap<String, String>) -> Result<(), TcHelperError> {
    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();

    let uuid_str = map
        .get("uuid")
        .ok_or_else(|| TcHelperError::InvalidUuid("<missing>".to_string()))?;
    let uuid = Uuid::parse_str(uuid_str).map_err(|_| TcHelperError::InvalidUuid(uuid_str.clone()))?;

    let mut t = replica
        .create_task(uuid, &mut ops)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?;
    let _ = t.set_status(taskchampion::Status::Pending, &mut ops);

    for (key, value) in map {
        match key.as_str() {
            "description" => {
                let _ = t.set_description(value, &mut ops);
            }
            "due" => {
                let _ = t.set_due(parse_datetime(&value), &mut ops);
            }
            "start" => {
                let _ = t.start(&mut ops);
            }
            "wait" => {
                let _ = t.set_wait(parse_datetime(&value), &mut ops);
            }
            "priority" => {
                let _ = t.set_priority(value, &mut ops);
            }
            "tags" => {
                for part in value.split_whitespace() {
                    if let Ok(mut tag) = Tag::from_str(part) {
                        let _ = t.add_tag(&mut tag, &mut ops);
                    }
                }
            }
            "project" => {
                let _ = t.set_user_defined_attribute("project", value, &mut ops);
            }
            _ => {}
        }
    }
    replica
        .commit_operations(ops)
        .map_err(|e| TcHelperError::Commit(e.to_string()))?;
    Ok(())
}

/// Synchronise the local replica with a remote TaskChampion sync server.
#[frb]
pub async fn sync(
    taskdb_dir_path: String,
    url: String,
    client_id: String,
    encryption_secret: String,
) -> Result<(), String> {
    sync_impl(&taskdb_dir_path, url, &client_id, encryption_secret).map_err(|e| e.to_string())
}

fn sync_impl(
    taskdb_dir_path: &str,
    url: String,
    client_id: &str,
    encryption_secret: String,
) -> Result<(), TcHelperError> {
    let mut replica = open_replica(taskdb_dir_path)?;
    let client_uuid =
        Uuid::parse_str(client_id).map_err(|_| TcHelperError::InvalidUuid(client_id.to_string()))?;

    let config = ServerConfig::Remote {
        url: url.into(),
        client_id: client_uuid,
        encryption_secret: encryption_secret.into(),
    };

    let mut server = config
        .into_server()
        .map_err(|e| TcHelperError::Sync(e.to_string()))?;
    replica
        .sync(&mut server, false)
        .map_err(|e| TcHelperError::Sync(e.to_string()))?;
    Ok(())
}

#[test]
fn test_add_task_with_tags() {
    use std::{collections::HashMap, env, fs};
    use serde_json::Value;

    // create unique temporary directory for taskdb
    let tmp = env::temp_dir().join(format!("taskdb_test_{}", Uuid::new_v4()));
    let taskdb_path = tmp.to_string_lossy().into_owned();
    fs::create_dir_all(&tmp).expect("create temp taskdb dir");

    // prepare task map with tags
    let mut map: HashMap<String, String> = HashMap::new();
    let uuid = Uuid::new_v4().to_string();
    map.insert("uuid".to_string(), uuid.clone());
    map.insert("description".to_string(), "test task".to_string());
    map.insert("tags".to_string(), "tag1 tag2".to_string());

    // add task
    add_task(taskdb_path.clone(), map).expect("add_task");

    // read tasks as json and verify the surfaced attributes
    let json = get_all_tasks_json(taskdb_path.clone()).expect("get_all_tasks_json");
    let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
    let task = tasks
        .into_iter()
        .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid.as_str()))
        .expect("task with uuid not found");

    let tags = task.get("tags").and_then(|t| t.as_str()).unwrap_or("");
    assert!(tags.contains("tag1"), "tag1 missing in tags: {}", tags);
    assert!(tags.contains("tag2"), "tag2 missing in tags: {}", tags);

    // newly surfaced attributes should be present with sensible defaults
    assert!(task.get("annotations").map(|v| v.is_array()).unwrap_or(false));
    assert!(task.get("depends").map(|v| v.is_array()).unwrap_or(false));
    assert_eq!(task.get("is_blocked").and_then(|v| v.as_bool()), Some(false));
    assert_eq!(task.get("is_blocking").and_then(|v| v.as_bool()), Some(false));

    // cleanup
    fs::remove_dir_all(&tmp).ok();
}
