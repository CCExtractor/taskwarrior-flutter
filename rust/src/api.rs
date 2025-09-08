use flutter_rust_bridge::frb;
use taskchampion::{
    chrono::{DateTime, Utc},
    Operations, Replica, ServerConfig, StorageConfig, Tag,
};
use uuid::Uuid;
use std::{collections::HashMap, path::PathBuf, str::FromStr};
use serde_json;

fn parse_datetime(input: &str) -> Option<DateTime<Utc>> {
    if input.trim().is_empty() {
        return None;
    }
    input.parse::<DateTime<Utc>>().ok()
}

#[frb]
pub fn get_all_tasks_json(taskdb_dir_path: String) -> Result<String, taskchampion::Error> {
    let tasks = get_all_tasks(taskdb_dir_path); // your Vec<HashMap<String, String>>
    let json = serde_json::to_string(&tasks)
        .map_err(|e| taskchampion::Error::Other(anyhow::anyhow!(e)))?;
    Ok(json)
}

fn get_all_tasks(taskdb_dir_path: String) -> Vec<HashMap<String, String>> {
    let taskdb_dir = PathBuf::from(taskdb_dir_path);
    let storage = StorageConfig::OnDisk {
        taskdb_dir,
        create_if_missing: true,
        access_mode: taskchampion::storage::AccessMode::ReadWrite,
    }
    .into_storage()
    .unwrap();

    let mut replica = Replica::new(storage);
    let mut vector: Vec<HashMap<String, String>> = Vec::new();

    for (_, value) in replica.all_tasks().unwrap() {
        let mut map: HashMap<String, String> = HashMap::new();
        let mut tags = String::new();

        for (k, v) in value.get_taskmap() {
            if k.contains("tag_") {
                if let Some(stripped) = k.strip_prefix("tag_") {
                    tags.push_str(stripped);
                }
            } else {
                map.insert(k.into(), v.into());
            }
        }
        map.insert("tags".into(), tags);
        map.insert("uuid".into(), value.get_uuid().to_string());
        vector.push(map);
    }
    vector
}

#[frb]
pub fn delete_task(uuid_st: String, taskdb_dir_path: String) -> i8 {
    let taskdb_dir = PathBuf::from(taskdb_dir_path);
    let storage = StorageConfig::OnDisk {
        taskdb_dir,
        create_if_missing: true,
        access_mode: taskchampion::storage::AccessMode::ReadWrite,
    }
    .into_storage()
    .unwrap();

    let mut replica = Replica::new(storage);
    let mut ops = Operations::new();
    let uuid = Uuid::parse_str(&uuid_st).unwrap();

    if let Some(mut t) = replica.get_task_data(uuid).unwrap() {
        t.delete(&mut ops);
    }
    replica.commit_operations(ops).unwrap();
    0
}

#[frb]
pub fn update_task(
    uuid_st: String,
    taskdb_dir_path: String,
    map: HashMap<String, String>,
) -> i8 {
    let taskdb_dir = PathBuf::from(taskdb_dir_path);
    let storage = StorageConfig::OnDisk {
        taskdb_dir,
        create_if_missing: true,
        access_mode: taskchampion::storage::AccessMode::ReadWrite,
    }
    .into_storage()
    .unwrap();

    let mut replica = Replica::new(storage);
    let mut ops = Operations::new();
    let uuid = Uuid::parse_str(&uuid_st).unwrap();

    if let Some(mut t) = replica.get_task(uuid).unwrap() {
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
                        let mut tag = Tag::from_str(part).unwrap();
                        let _ = t.add_tag(&mut tag, &mut ops);
                    }
                }
                "project" => {
                    let _ = t.set_user_defined_attribute("project", value, &mut ops);
                }
                _ => {}
            }
        }
        replica.commit_operations(ops).unwrap();
    }
    0
}

#[frb]
pub fn add_task(taskdb_dir_path: String, map: HashMap<String, String>) -> i8 {
    let taskdb_dir = PathBuf::from(taskdb_dir_path);
    let storage = StorageConfig::OnDisk {
        taskdb_dir,
        create_if_missing: true,
        access_mode: taskchampion::storage::AccessMode::ReadWrite,
    }
    .into_storage()
    .unwrap();

    let mut replica = Replica::new(storage);
    let mut ops = Operations::new();
    if let Some(uuid_str) = map.get("uuid") {
    let uuid = Uuid::parse_str(&uuid_str).unwrap();
    let mut t = replica.create_task(uuid, &mut ops).unwrap();

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
                    let mut tag = Tag::from_str(part).unwrap();
                    let _ = t.add_tag(&mut tag, &mut ops);
                }
            }
            "project" => {
                let _ = t.set_user_defined_attribute("project", value, &mut ops);
            }
            _ => {}
        }
    }
    replica.commit_operations(ops).unwrap();
    return 0;
} 
    1
}

#[frb]
pub async fn sync(
    taskdb_dir_path: String,
    url: String,
    client_id: String,
    encryption_secret: String,
) -> i8 {
    let taskdb_dir = PathBuf::from(taskdb_dir_path);
    let storage = StorageConfig::OnDisk {
        taskdb_dir,
        create_if_missing: true,
        access_mode: taskchampion::storage::AccessMode::ReadWrite,
    }
    .into_storage()
    .unwrap();

    let mut replica = Replica::new(storage);
    let config = ServerConfig::Remote {
        url: url.into(),
        client_id: Uuid::parse_str(&client_id).unwrap(),
        encryption_secret: encryption_secret.into(),
    };

    let mut server = config.into_server().unwrap();
    replica.sync(&mut server, false).unwrap();
    0
}
