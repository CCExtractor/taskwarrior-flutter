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
///
/// This is a *soft* delete, matching what `task delete` does in the Taskwarrior
/// CLI: the task's status becomes `deleted` but the record is preserved, so it
/// still syncs, remains auditable, and can be restored (`task undelete`).
/// Previously this purged the task from the replica outright via
/// `TaskData::delete()`, which is the equivalent of `task purge` — the data was
/// unrecoverable and never appeared in a "deleted" view on any client.
#[frb]
pub fn delete_task(uuid_st: String, taskdb_dir_path: String) -> Result<(), String> {
    delete_task_impl(&uuid_st, &taskdb_dir_path).map_err(|e| e.to_string())
}

fn delete_task_impl(uuid_st: &str, taskdb_dir_path: &str) -> Result<(), TcHelperError> {
    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();
    let uuid = Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;

    if let Some(mut t) = replica
        .get_task(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
    {
        t.set_status(taskchampion::Status::Deleted, &mut ops)
            .map_err(|e| TcHelperError::Champion(e.to_string()))?;
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
        // NOTE: do not force the status here. This used to unconditionally set
        // Pending before applying the map, so any update that didn't carry an
        // explicit "status" silently resurrected a completed or deleted task.
        // Status is applied below only when the caller actually supplies it.
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

#[test]
fn test_dependencies_and_annotations_surface() {
    // Exercises the POPULATED cases of the enriched serializer: a real
    // dependency (A depends on B) must surface as depends[]/is_blocked/is_blocking,
    // and an annotation must surface as {entry (RFC3339), description}.
    use std::{env, fs};
    use serde_json::Value;
    use taskchampion::{chrono::{DateTime, Utc}, Annotation, Operations, Status};

    let tmp = env::temp_dir().join(format!("taskdb_deptest_{}", Uuid::new_v4()));
    let taskdb_path = tmp.to_string_lossy().into_owned();
    fs::create_dir_all(&tmp).expect("create temp taskdb dir");

    let uuid_a = Uuid::new_v4(); // dependent task
    let uuid_b = Uuid::new_v4(); // blocker task

    {
        let mut replica = open_replica(&taskdb_path).expect("open replica");
        let mut ops = Operations::new();

        let mut b = replica.create_task(uuid_b, &mut ops).expect("create B");
        let _ = b.set_status(Status::Pending, &mut ops);
        let _ = b.set_description("blocker".to_string(), &mut ops);

        let mut a = replica.create_task(uuid_a, &mut ops).expect("create A");
        let _ = a.set_status(Status::Pending, &mut ops);
        let _ = a.set_description("dependent".to_string(), &mut ops);
        a.add_dependency(uuid_b, &mut ops).expect("add dependency A->B");
        a.add_annotation(
            Annotation { entry: Utc::now(), description: "note-one".to_string() },
            &mut ops,
        ).expect("add annotation");

        replica.commit_operations(ops).expect("commit");
    }

    // Read back through the SAME path the app uses (fresh replica + all_tasks()).
    let json = get_all_tasks_json(taskdb_path.clone()).expect("get_all_tasks_json");
    let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
    let find = |u: &Uuid| {
        tasks
            .iter()
            .find(|t| t.get("uuid").and_then(|v| v.as_str()) == Some(u.to_string().as_str()))
            .cloned()
            .expect("task present")
    };
    let a = find(&uuid_a);
    let b = find(&uuid_b);

    // A depends on B → depends[] carries B, and A is blocked (unresolved dep).
    let deps: Vec<String> = a["depends"].as_array().unwrap()
        .iter().map(|v| v.as_str().unwrap().to_string()).collect();
    assert!(deps.contains(&uuid_b.to_string()), "A.depends must contain B: {:?}", deps);
    assert_eq!(a["is_blocked"].as_bool(), Some(true), "A must be blocked");
    assert_eq!(a["is_blocking"].as_bool(), Some(false), "A must not be blocking");

    // A's annotation surfaces with description + RFC3339 entry.
    let anns = a["annotations"].as_array().unwrap();
    assert_eq!(anns.len(), 1, "A must have one annotation");
    assert_eq!(anns[0]["description"].as_str(), Some("note-one"));
    let entry = anns[0]["entry"].as_str().unwrap();
    assert!(DateTime::parse_from_rfc3339(entry).is_ok(), "entry must be RFC3339: {}", entry);

    // B is depended-upon → B is blocking, not blocked.
    assert_eq!(b["is_blocking"].as_bool(), Some(true), "B must be blocking");
    assert_eq!(b["is_blocked"].as_bool(), Some(false), "B must not be blocked");

    fs::remove_dir_all(&tmp).ok();
}

#[test]
fn test_delete_task_is_a_soft_delete() {
    // `task delete` in the Taskwarrior CLI is a *soft* delete: the record
    // survives with status=deleted so it still syncs and can be restored.
    // This previously used TaskData::delete(), which purged the task outright
    // (the `task purge` equivalent) and left nothing to recover or display.
    use std::{collections::HashMap, env, fs};
    use serde_json::Value;

    let tmp = env::temp_dir().join(format!("taskdb_deltest_{}", Uuid::new_v4()));
    let taskdb_path = tmp.to_string_lossy().into_owned();
    fs::create_dir_all(&tmp).expect("create temp taskdb dir");

    let uuid = Uuid::new_v4().to_string();
    let mut map: HashMap<String, String> = HashMap::new();
    map.insert("uuid".to_string(), uuid.clone());
    map.insert("description".to_string(), "doomed task".to_string());
    add_task(taskdb_path.clone(), map).expect("add_task");

    delete_task(uuid.clone(), taskdb_path.clone()).expect("delete_task");

    let json = get_all_tasks_json(taskdb_path.clone()).expect("get_all_tasks_json");
    let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
    let task = tasks
        .into_iter()
        .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid.as_str()));

    // The task must still exist...
    let task = task.expect("deleted task was purged from the replica, not soft-deleted");
    // ...and be marked deleted rather than left pending.
    assert_eq!(
        task.get("status").and_then(|v| v.as_str()),
        Some("deleted"),
        "expected status=deleted after delete_task"
    );

    fs::remove_dir_all(&tmp).ok();
}

#[test]
fn test_update_preserves_status_when_not_supplied() {
    // Regression: update_task_impl used to force Status::Pending before
    // applying the caller's map, so editing (say) a description on a deleted
    // or completed task silently resurrected it as pending — which would also
    // quietly undo a soft delete.
    use std::{collections::HashMap, env, fs};
    use serde_json::Value;

    let tmp = env::temp_dir().join(format!("taskdb_statustest_{}", Uuid::new_v4()));
    let taskdb_path = tmp.to_string_lossy().into_owned();
    fs::create_dir_all(&tmp).expect("create temp taskdb dir");

    let uuid = Uuid::new_v4().to_string();
    let mut map: HashMap<String, String> = HashMap::new();
    map.insert("uuid".to_string(), uuid.clone());
    map.insert("description".to_string(), "will be deleted".to_string());
    add_task(taskdb_path.clone(), map).expect("add_task");
    delete_task(uuid.clone(), taskdb_path.clone()).expect("delete_task");

    // Edit only the description — no "status" key in the map.
    let mut edit: HashMap<String, String> = HashMap::new();
    edit.insert("description".to_string(), "renamed".to_string());
    update_task(uuid.clone(), taskdb_path.clone(), edit).expect("update_task");

    let json = get_all_tasks_json(taskdb_path.clone()).expect("get_all_tasks_json");
    let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
    let task = tasks
        .into_iter()
        .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid.as_str()))
        .expect("task missing");

    assert_eq!(
        task.get("description").and_then(|v| v.as_str()),
        Some("renamed"),
        "the description edit should have applied"
    );
    assert_eq!(
        task.get("status").and_then(|v| v.as_str()),
        Some("deleted"),
        "editing a deleted task must not resurrect it to pending"
    );

    fs::remove_dir_all(&tmp).ok();
}
