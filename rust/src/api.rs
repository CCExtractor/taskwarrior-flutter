use flutter_rust_bridge::frb;
use std::{collections::HashMap, str::FromStr};
use taskchampion::{
    chrono::{DateTime, Utc},
    utc_timestamp, Annotation, Operations, ServerConfig, Tag,
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
        // Recurrence is only valid alongside a due date, and the consequence of
        // breaking that is destructive rather than inert: the Taskwarrior CLI
        // deletes a recurring task that has no due date the next time it runs.
        // Since this app cannot generate instances itself, the value it writes is
        // acted on by that CLI — so the invariant is enforced here, before
        // anything is committed, rather than trusted to the UI.
        let recur_after = match map.get("recur") {
            Some(v) => v.trim().to_string(),
            None => t.get_value("recur").unwrap_or("").trim().to_string(),
        };
        if !recur_after.is_empty() {
            let due_after = match map.get("due") {
                Some(v) => parse_datetime(v),
                None => t.get_due(),
            };
            if due_after.is_none() {
                return Err(TcHelperError::InvalidInput(
                    "a repeating task needs a due date — Taskwarrior deletes a \
                     recurring task that has none"
                        .to_string(),
                ));
            }
        }

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
                // Stored like `project`: an opaque string TaskChampion keeps but
                // never interprets. Unlike `project`, nothing in this app acts on
                // it — instances are generated by the desktop Taskwarrior CLI when
                // it next opens the same database. An empty value clears it.
                "recur" => {
                    let trimmed = value.trim();
                    let _ = t.set_value(
                        "recur",
                        if trimmed.is_empty() {
                            None
                        } else {
                            Some(trimmed.to_string())
                        },
                        &mut ops,
                    );
                }
                "status" => {
                    let _ = t.set_status(parse_status(&value)?, &mut ops);
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

/// The one place a status string is turned into a `Status`.
///
/// Both `add_task` and `update_task` go through this. They used to carry their
/// own idea of which statuses existed, which is how `recurring` came to be
/// writable through one entry point and silently dropped by the other. An
/// unrecognised value is refused rather than coerced, so a caller with a bug
/// hears about it instead of quietly getting a pending task.
fn parse_status(value: &str) -> Result<taskchampion::Status, TcHelperError> {
    match value {
        "pending" => Ok(taskchampion::Status::Pending),
        "completed" => Ok(taskchampion::Status::Completed),
        "deleted" => Ok(taskchampion::Status::Deleted),
        // A recurrence template. The Taskwarrior CLI only generates instances
        // for a task whose status is `recurring`.
        "recurring" => Ok(taskchampion::Status::Recurring),
        other => Err(TcHelperError::InvalidInput(format!(
            "unknown status '{other}' — expected pending, completed, deleted \
             or recurring"
        ))),
    }
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

    // Same invariant update_task enforces: Taskwarrior deletes a recurring task
    // that has no due date the next time it runs. On a new task the map is the
    // whole of the state, so there is nothing to read back.
    if map.get("recur").is_some_and(|v| !v.trim().is_empty())
        && map.get("due").and_then(|v| parse_datetime(v)).is_none()
    {
        return Err(TcHelperError::InvalidInput(
            "a repeating task needs a due date — Taskwarrior deletes a \
             recurring task that has none"
                .to_string(),
        ));
    }

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
            // Both of these used to fall into the catch-all below. Replica.attrs
            // on the Dart side lists them as round-trippable and sends them
            // through this same map, so a task created with a repeat or an
            // explicit status had that silently discarded while the write
            // reported success.
            "recur" => {
                let trimmed = value.trim();
                let _ = t.set_value(
                    "recur",
                    if trimmed.is_empty() {
                        None
                    } else {
                        Some(trimmed.to_string())
                    },
                    &mut ops,
                );
            }
            "status" => {
                let _ = t.set_status(parse_status(&value)?, &mut ops);
            }
            // Consumed above to create the task.
            "uuid" => {}
            // Every key Replica.attrs can send is handled above, so reaching
            // here means the two sides have drifted apart. Say so.
            other => {
                return Err(TcHelperError::InvalidInput(format!(
                    "unknown attribute '{other}'"
                )))
            }
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

/// Attach a timestamped note (annotation) to a task, returning the entry
/// timestamp that identifies it.
///
/// TaskChampion stores an annotation as an `annotation_<epoch-seconds>`
/// property, so **the entry time is the annotation's primary key** — two notes
/// on the same task in the same second would collide and the later one would
/// silently replace the earlier. The Taskwarrior CLI has that behaviour too,
/// but a phone makes it far easier to hit (two quick taps on Add). Rather than
/// destroy a note, this advances to the next free second. The result is still
/// an ordinary annotation that any Taskwarrior client reads normally; only the
/// recorded time differs, by a second or two.
///
/// The returned RFC 3339 string is what [`remove_annotation`] expects, so a
/// caller can delete the note it just created without re-reading the task.
#[frb]
pub fn add_annotation(
    uuid_st: String,
    description: String,
    taskdb_dir_path: String,
) -> Result<String, String> {
    add_annotation_impl(&uuid_st, &description, &taskdb_dir_path).map_err(|e| e.to_string())
}

fn add_annotation_impl(
    uuid_st: &str,
    description: &str,
    taskdb_dir_path: &str,
) -> Result<String, TcHelperError> {
    let description = description.trim();
    if description.is_empty() {
        return Err(TcHelperError::InvalidInput(
            "annotation text cannot be empty".to_string(),
        ));
    }

    let uuid =
        Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;
    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();

    let mut task = replica
        .get_task(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
        .ok_or_else(|| TcHelperError::TaskNotFound(uuid_st.to_string()))?;

    // Whole seconds only: get_annotations() rebuilds each entry from the
    // integer in the property key, so any sub-second precision is discarded on
    // read anyway. Comparing at the same resolution is what makes the
    // collision check meaningful.
    let taken: std::collections::HashSet<i64> =
        task.get_annotations().map(|a| a.entry.timestamp()).collect();

    let mut secs = Utc::now().timestamp();
    // Bounded so a pathological replica can never spin here. A day of
    // consecutively-occupied seconds is not a real state; failing loudly beats
    // looping.
    let limit = secs + 86_400;
    while taken.contains(&secs) {
        secs += 1;
        if secs > limit {
            return Err(TcHelperError::InvalidInput(
                "could not find a free annotation timestamp".to_string(),
            ));
        }
    }
    let entry = utc_timestamp(secs);

    task.add_annotation(
        Annotation {
            entry,
            description: description.to_string(),
        },
        &mut ops,
    )
    .map_err(|e| TcHelperError::Champion(e.to_string()))?;

    replica
        .commit_operations(ops)
        .map_err(|e| TcHelperError::Commit(e.to_string()))?;

    Ok(entry.to_rfc3339())
}

/// Remove the annotation identified by `entry_rfc3339` from a task.
///
/// The timestamp must be one returned by the serializer (or by
/// [`add_annotation`]); it is matched at whole-second resolution, which is how
/// TaskChampion keys annotations. Removing an annotation that is not present is
/// a no-op rather than an error, so a double-tap on delete cannot fail.
#[frb]
pub fn remove_annotation(
    uuid_st: String,
    entry_rfc3339: String,
    taskdb_dir_path: String,
) -> Result<(), String> {
    remove_annotation_impl(&uuid_st, &entry_rfc3339, &taskdb_dir_path).map_err(|e| e.to_string())
}

fn remove_annotation_impl(
    uuid_st: &str,
    entry_rfc3339: &str,
    taskdb_dir_path: &str,
) -> Result<(), TcHelperError> {
    let uuid =
        Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;

    let entry = DateTime::parse_from_rfc3339(entry_rfc3339)
        .map_err(|_| {
            TcHelperError::InvalidInput(format!(
                "annotation entry '{entry_rfc3339}' is not a valid RFC 3339 timestamp"
            ))
        })?
        .with_timezone(&Utc);

    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();

    let mut task = replica
        .get_task(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
        .ok_or_else(|| TcHelperError::TaskNotFound(uuid_st.to_string()))?;

    // Normalise to whole seconds so a caller passing a timestamp with a
    // fractional part still targets the right property key.
    task.remove_annotation(utc_timestamp(entry.timestamp()), &mut ops)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?;

    replica
        .commit_operations(ops)
        .map_err(|e| TcHelperError::Commit(e.to_string()))?;
    Ok(())
}

/// Does a dependency path lead from `from` to `target`?
///
/// Used to reject an edge that would close a loop. Iterative rather than
/// recursive so a long chain cannot overflow the stack, and `seen` means a cycle
/// already present in the data — one another client could have written, since
/// nothing in TaskChampion prevents it — terminates the walk instead of hanging.
fn dependency_path_exists(
    tasks: &HashMap<Uuid, taskchampion::Task>,
    from: Uuid,
    target: Uuid,
) -> bool {
    let mut stack = vec![from];
    let mut seen: std::collections::HashSet<Uuid> = std::collections::HashSet::new();
    while let Some(current) = stack.pop() {
        if current == target {
            return true;
        }
        if !seen.insert(current) {
            continue;
        }
        if let Some(task) = tasks.get(&current) {
            stack.extend(task.get_dependencies());
        }
    }
    false
}

/// Make `uuid_st` depend on `depends_on_st`, so the first is blocked until the
/// second is done.
///
/// TaskChampion's own `add_dependency` validates nothing at all — it writes a
/// `dep_<uuid>` property and returns. It will accept a task depending on itself,
/// on a UUID that is not a task, or on something that already depends on it.
/// None of those crash, but a cycle leaves both tasks permanently blocked and
/// never "ready", with nothing to explain why. So the checks live here:
///
/// * a task may not depend on itself
/// * both tasks must exist
/// * the edge must not close a loop
///
/// Adding a dependency that is already present is a no-op, not an error.
#[frb]
pub fn add_dependency(
    uuid_st: String,
    depends_on_st: String,
    taskdb_dir_path: String,
) -> Result<(), String> {
    add_dependency_impl(&uuid_st, &depends_on_st, &taskdb_dir_path).map_err(|e| e.to_string())
}

fn add_dependency_impl(
    uuid_st: &str,
    depends_on_st: &str,
    taskdb_dir_path: &str,
) -> Result<(), TcHelperError> {
    let uuid =
        Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;
    let depends_on = Uuid::parse_str(depends_on_st)
        .map_err(|_| TcHelperError::InvalidUuid(depends_on_st.to_string()))?;

    if uuid == depends_on {
        return Err(TcHelperError::InvalidInput(
            "a task cannot depend on itself".to_string(),
        ));
    }

    let mut replica = open_replica(taskdb_dir_path)?;
    let tasks = replica
        .all_tasks()
        .map_err(|e| TcHelperError::Champion(e.to_string()))?;

    let task = tasks
        .get(&uuid)
        .ok_or_else(|| TcHelperError::TaskNotFound(uuid_st.to_string()))?;
    if !tasks.contains_key(&depends_on) {
        return Err(TcHelperError::TaskNotFound(depends_on_st.to_string()));
    }

    if task.get_dependencies().any(|d| d == depends_on) {
        return Ok(());
    }

    // The new edge is uuid -> depends_on, so it closes a loop exactly when
    // depends_on can already reach uuid.
    if dependency_path_exists(&tasks, depends_on, uuid) {
        return Err(TcHelperError::InvalidInput(
            "that would create a circular dependency".to_string(),
        ));
    }

    let mut ops = Operations::new();
    let mut task = replica
        .get_task(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
        .ok_or_else(|| TcHelperError::TaskNotFound(uuid_st.to_string()))?;
    task.add_dependency(depends_on, &mut ops)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?;
    replica
        .commit_operations(ops)
        .map_err(|e| TcHelperError::Commit(e.to_string()))?;
    Ok(())
}

/// Drop a dependency of `uuid_st` on `depends_on_st`.
///
/// Removing one that is not there is a no-op, and the depended-on task need not
/// exist — that is deliberate, so a dependency left dangling by another client
/// can still be cleared.
#[frb]
pub fn remove_dependency(
    uuid_st: String,
    depends_on_st: String,
    taskdb_dir_path: String,
) -> Result<(), String> {
    remove_dependency_impl(&uuid_st, &depends_on_st, &taskdb_dir_path).map_err(|e| e.to_string())
}

fn remove_dependency_impl(
    uuid_st: &str,
    depends_on_st: &str,
    taskdb_dir_path: &str,
) -> Result<(), TcHelperError> {
    let uuid =
        Uuid::parse_str(uuid_st).map_err(|_| TcHelperError::InvalidUuid(uuid_st.to_string()))?;
    let depends_on = Uuid::parse_str(depends_on_st)
        .map_err(|_| TcHelperError::InvalidUuid(depends_on_st.to_string()))?;

    let mut replica = open_replica(taskdb_dir_path)?;
    let mut ops = Operations::new();
    let mut task = replica
        .get_task(uuid)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?
        .ok_or_else(|| TcHelperError::TaskNotFound(uuid_st.to_string()))?;

    task.remove_dependency(depends_on, &mut ops)
        .map_err(|e| TcHelperError::Champion(e.to_string()))?;
    replica
        .commit_operations(ops)
        .map_err(|e| TcHelperError::Commit(e.to_string()))?;
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

#[cfg(test)]
mod annotation_tests {
    use super::*;
    use serde_json::Value;
    use std::{collections::HashMap, env, fs};

    /// Create a temp replica holding one task, returning (dir, path, uuid).
    fn task_fixture() -> (std::path::PathBuf, String, String) {
        let tmp = env::temp_dir().join(format!("taskdb_ann_{}", Uuid::new_v4()));
        fs::create_dir_all(&tmp).expect("create temp taskdb dir");
        let path = tmp.to_string_lossy().into_owned();

        let uuid = Uuid::new_v4().to_string();
        let mut map: HashMap<String, String> = HashMap::new();
        map.insert("uuid".to_string(), uuid.clone());
        map.insert("description".to_string(), "annotated task".to_string());
        add_task(path.clone(), map).expect("add_task");

        (tmp, path, uuid)
    }

    /// Read back the annotations of `uuid` as (entry, description) pairs.
    fn annotations_of(path: &str, uuid: &str) -> Vec<(String, String)> {
        let json = get_all_tasks_json(path.to_string()).expect("get_all_tasks_json");
        let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
        let task = tasks
            .into_iter()
            .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid))
            .expect("task not found");
        task.get("annotations")
            .and_then(|a| a.as_array())
            .expect("annotations array")
            .iter()
            .map(|a| {
                (
                    a["entry"].as_str().unwrap_or_default().to_string(),
                    a["description"].as_str().unwrap_or_default().to_string(),
                )
            })
            .collect()
    }

    #[test]
    fn add_then_read_back() {
        let (tmp, path, uuid) = task_fixture();

        let entry = add_annotation(uuid.clone(), "  bought the paint  ".to_string(), path.clone())
            .expect("add_annotation");

        let anns = annotations_of(&path, &uuid);
        assert_eq!(anns.len(), 1);
        // Surrounding whitespace is trimmed before storing.
        assert_eq!(anns[0].1, "bought the paint");
        // The returned entry is exactly what the serializer reports, so a caller
        // can delete the note it just made without re-reading the task.
        assert_eq!(anns[0].0, entry);

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn two_annotations_in_the_same_second_both_survive() {
        // The regression this guards: TaskChampion keys an annotation by its
        // entry time in whole seconds, so a naive implementation would let the
        // second call overwrite the first when both land in the same second —
        // which is exactly what two quick taps on "Add" produce.
        let (tmp, path, uuid) = task_fixture();

        let first = add_annotation(uuid.clone(), "first note".to_string(), path.clone())
            .expect("add first");
        let second = add_annotation(uuid.clone(), "second note".to_string(), path.clone())
            .expect("add second");

        assert_ne!(first, second, "the two notes must not share an entry key");

        let anns = annotations_of(&path, &uuid);
        assert_eq!(anns.len(), 2, "both notes must survive: {anns:?}");
        let mut descriptions: Vec<&str> = anns.iter().map(|(_, d)| d.as_str()).collect();
        descriptions.sort_unstable();
        assert_eq!(descriptions, vec!["first note", "second note"]);

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn remove_deletes_only_the_targeted_note() {
        let (tmp, path, uuid) = task_fixture();

        let keep = add_annotation(uuid.clone(), "keep me".to_string(), path.clone()).unwrap();
        let drop = add_annotation(uuid.clone(), "drop me".to_string(), path.clone()).unwrap();

        remove_annotation(uuid.clone(), drop, path.clone()).expect("remove_annotation");

        let anns = annotations_of(&path, &uuid);
        assert_eq!(anns.len(), 1, "exactly one note should remain: {anns:?}");
        assert_eq!(anns[0].1, "keep me");
        assert_eq!(anns[0].0, keep);

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn removing_a_missing_annotation_is_a_no_op() {
        // A double-tap on delete must not surface an error.
        let (tmp, path, uuid) = task_fixture();
        let entry = add_annotation(uuid.clone(), "only note".to_string(), path.clone()).unwrap();

        remove_annotation(uuid.clone(), entry.clone(), path.clone()).expect("first remove");
        remove_annotation(uuid.clone(), entry, path.clone()).expect("second remove must not error");

        assert!(annotations_of(&path, &uuid).is_empty());

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn empty_text_is_rejected() {
        let (tmp, path, uuid) = task_fixture();

        let err = add_annotation(uuid.clone(), "   ".to_string(), path.clone())
            .expect_err("whitespace-only text must be rejected");
        assert!(err.contains("empty"), "unhelpful error: {err}");
        assert!(annotations_of(&path, &uuid).is_empty());

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn unknown_task_and_bad_input_report_clearly() {
        let (tmp, path, uuid) = task_fixture();

        let missing = Uuid::new_v4().to_string();
        let err = add_annotation(missing.clone(), "note".to_string(), path.clone())
            .expect_err("unknown task must error");
        assert!(err.contains("no task with UUID"), "unhelpful error: {err}");

        let err = add_annotation("not-a-uuid".to_string(), "note".to_string(), path.clone())
            .expect_err("malformed uuid must error");
        assert!(err.contains("invalid UUID"), "unhelpful error: {err}");

        let err = remove_annotation(uuid, "yesterday".to_string(), path.clone())
            .expect_err("malformed timestamp must error");
        assert!(err.contains("RFC 3339"), "unhelpful error: {err}");

        fs::remove_dir_all(&tmp).ok();
    }
}

#[cfg(test)]
mod dependency_tests {
    use super::*;
    use serde_json::Value;
    use std::{collections::HashMap, env, fs};

    /// A temp replica with `n` tasks, returning (dir, path, uuids).
    fn tasks_fixture(n: usize) -> (std::path::PathBuf, String, Vec<String>) {
        let tmp = env::temp_dir().join(format!("taskdb_dep_{}", Uuid::new_v4()));
        fs::create_dir_all(&tmp).expect("create temp taskdb dir");
        let path = tmp.to_string_lossy().into_owned();

        let mut uuids = Vec::new();
        for i in 0..n {
            let uuid = Uuid::new_v4().to_string();
            let mut map: HashMap<String, String> = HashMap::new();
            map.insert("uuid".to_string(), uuid.clone());
            map.insert("description".to_string(), format!("task {i}"));
            add_task(path.clone(), map).expect("add_task");
            uuids.push(uuid);
        }
        (tmp, path, uuids)
    }

    fn task_json(path: &str, uuid: &str) -> Value {
        let json = get_all_tasks_json(path.to_string()).expect("get_all_tasks_json");
        let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
        tasks
            .into_iter()
            .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid))
            .expect("task not found")
    }

    #[test]
    fn add_then_surfaces_as_depends_and_blocking() {
        let (tmp, path, u) = tasks_fixture(2);
        let (a, b) = (u[0].clone(), u[1].clone());

        add_dependency(a.clone(), b.clone(), path.clone()).expect("add_dependency");

        let ja = task_json(&path, &a);
        let deps: Vec<&str> = ja["depends"]
            .as_array()
            .unwrap()
            .iter()
            .map(|d| d.as_str().unwrap())
            .collect();
        assert_eq!(deps, vec![b.as_str()]);
        assert_eq!(ja["is_blocked"].as_bool(), Some(true), "A depends on B");
        assert_eq!(ja["is_blocking"].as_bool(), Some(false));

        // The reverse view updates with no extra work, because each FFI call
        // opens a fresh replica and so rebuilds the dependency map.
        let jb = task_json(&path, &b);
        assert_eq!(jb["is_blocking"].as_bool(), Some(true), "B blocks A");
        assert_eq!(jb["is_blocked"].as_bool(), Some(false));

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn a_task_cannot_depend_on_itself() {
        let (tmp, path, u) = tasks_fixture(1);
        let err = add_dependency(u[0].clone(), u[0].clone(), path.clone())
            .expect_err("self-dependency must be refused");
        assert!(err.contains("cannot depend on itself"), "unhelpful: {err}");
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn the_other_task_must_exist() {
        let (tmp, path, u) = tasks_fixture(1);
        let ghost = Uuid::new_v4().to_string();
        let err = add_dependency(u[0].clone(), ghost, path.clone())
            .expect_err("depending on a non-task must be refused");
        assert!(err.contains("no task with UUID"), "unhelpful: {err}");
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn a_direct_cycle_is_refused() {
        // A -> B is fine; B -> A would leave both permanently blocked and never
        // ready, which TaskChampion itself does nothing to prevent.
        let (tmp, path, u) = tasks_fixture(2);
        let (a, b) = (u[0].clone(), u[1].clone());

        add_dependency(a.clone(), b.clone(), path.clone()).expect("A -> B");
        let err = add_dependency(b.clone(), a.clone(), path.clone())
            .expect_err("B -> A must be refused");
        assert!(err.contains("circular"), "unhelpful: {err}");

        // and the refusal must not have written anything
        let jb = task_json(&path, &b);
        assert!(jb["depends"].as_array().unwrap().is_empty());

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn an_indirect_cycle_is_refused() {
        // A -> B -> C, then C -> A closes the loop three edges later.
        let (tmp, path, u) = tasks_fixture(3);
        let (a, b, c) = (u[0].clone(), u[1].clone(), u[2].clone());

        add_dependency(a.clone(), b.clone(), path.clone()).expect("A -> B");
        add_dependency(b.clone(), c.clone(), path.clone()).expect("B -> C");
        let err = add_dependency(c.clone(), a.clone(), path.clone())
            .expect_err("C -> A must be refused");
        assert!(err.contains("circular"), "unhelpful: {err}");

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn a_diamond_is_allowed() {
        // Not every repeated path is a cycle: A -> B, A -> C, B -> D, C -> D is
        // a diamond and perfectly legal. A naive "have I seen D twice" check
        // would wrongly reject it.
        let (tmp, path, u) = tasks_fixture(4);
        let (a, b, c, d) = (u[0].clone(), u[1].clone(), u[2].clone(), u[3].clone());

        add_dependency(a.clone(), b.clone(), path.clone()).expect("A -> B");
        add_dependency(a.clone(), c.clone(), path.clone()).expect("A -> C");
        add_dependency(b.clone(), d.clone(), path.clone()).expect("B -> D");
        add_dependency(c, d, path.clone()).expect("C -> D must be allowed");

        assert_eq!(task_json(&path, &a)["depends"].as_array().unwrap().len(), 2);
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn adding_twice_is_a_no_op() {
        let (tmp, path, u) = tasks_fixture(2);
        let (a, b) = (u[0].clone(), u[1].clone());

        add_dependency(a.clone(), b.clone(), path.clone()).expect("first");
        add_dependency(a.clone(), b.clone(), path.clone()).expect("second must not error");

        assert_eq!(task_json(&path, &a)["depends"].as_array().unwrap().len(), 1);
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn remove_clears_the_edge_and_is_idempotent() {
        let (tmp, path, u) = tasks_fixture(2);
        let (a, b) = (u[0].clone(), u[1].clone());

        add_dependency(a.clone(), b.clone(), path.clone()).expect("add");
        remove_dependency(a.clone(), b.clone(), path.clone()).expect("remove");
        remove_dependency(a.clone(), b.clone(), path.clone()).expect("second remove must not error");

        let ja = task_json(&path, &a);
        assert!(ja["depends"].as_array().unwrap().is_empty());
        assert_eq!(ja["is_blocked"].as_bool(), Some(false));
        assert_eq!(
            task_json(&path, &b)["is_blocking"].as_bool(),
            Some(false),
            "B should no longer block anything"
        );

        fs::remove_dir_all(&tmp).ok();
    }
}

#[cfg(test)]
mod recurrence_tests {
    use super::*;
    use serde_json::Value;
    use std::{collections::HashMap, env, fs};

    fn fixture(due: Option<&str>) -> (std::path::PathBuf, String, String) {
        let tmp = env::temp_dir().join(format!("taskdb_recur_{}", Uuid::new_v4()));
        fs::create_dir_all(&tmp).expect("create temp taskdb dir");
        let path = tmp.to_string_lossy().into_owned();

        let uuid = Uuid::new_v4().to_string();
        let mut map: HashMap<String, String> = HashMap::new();
        map.insert("uuid".to_string(), uuid.clone());
        map.insert("description".to_string(), "chore".to_string());
        if let Some(d) = due {
            map.insert("due".to_string(), d.to_string());
        }
        add_task(path.clone(), map).expect("add_task");
        (tmp, path, uuid)
    }

    fn field(path: &str, uuid: &str, key: &str) -> Option<String> {
        let json = get_all_tasks_json(path.to_string()).expect("get_all_tasks_json");
        let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
        tasks
            .into_iter()
            .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid))
            .and_then(|t| t.get(key).and_then(|v| v.as_str()).map(|s| s.to_string()))
    }

    fn update(path: &str, uuid: &str, pairs: &[(&str, &str)]) -> Result<(), String> {
        let map: HashMap<String, String> = pairs
            .iter()
            .map(|(k, v)| (k.to_string(), v.to_string()))
            .collect();
        update_task(uuid.to_string(), path.to_string(), map)
    }

    #[test]
    fn recur_is_stored_when_the_task_has_a_due_date() {
        let (tmp, path, uuid) = fixture(Some("2026-09-01T09:00:00Z"));

        update(&path, &uuid, &[("recur", "weekly")]).expect("should be allowed");

        assert_eq!(field(&path, &uuid, "recur").as_deref(), Some("weekly"));
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn recur_is_refused_without_a_due_date() {
        // The consequence of allowing this is not a broken field but a destroyed
        // task: the Taskwarrior CLI deletes a recurring task with no due date.
        let (tmp, path, uuid) = fixture(None);

        let err = update(&path, &uuid, &[("recur", "weekly")])
            .expect_err("must be refused");
        assert!(err.contains("needs a due date"), "unhelpful: {err}");
        assert_eq!(field(&path, &uuid, "recur"), None, "nothing may be written");

        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn recur_and_due_may_be_set_in_one_call() {
        // The check must look at the state *after* the update, not before, or
        // setting both at once would be wrongly rejected.
        let (tmp, path, uuid) = fixture(None);

        update(
            &path,
            &uuid,
            &[("recur", "monthly"), ("due", "2026-09-01T09:00:00Z")],
        )
        .expect("setting both together should be allowed");

        assert_eq!(field(&path, &uuid, "recur").as_deref(), Some("monthly"));
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn the_due_date_cannot_be_stripped_while_recur_is_set() {
        let (tmp, path, uuid) = fixture(Some("2026-09-01T09:00:00Z"));
        update(&path, &uuid, &[("recur", "weekly")]).expect("set recur");

        let err = update(&path, &uuid, &[("due", "")])
            .expect_err("removing due must be refused while recurring");
        assert!(err.contains("needs a due date"), "unhelpful: {err}");

        // the due date must survive the refusal
        assert!(field(&path, &uuid, "due").is_some());
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn clearing_recur_then_releases_the_due_date() {
        let (tmp, path, uuid) = fixture(Some("2026-09-01T09:00:00Z"));
        update(&path, &uuid, &[("recur", "weekly")]).expect("set recur");

        update(&path, &uuid, &[("recur", "")]).expect("clearing recur is allowed");
        assert_eq!(field(&path, &uuid, "recur"), None);

        update(&path, &uuid, &[("due", "")]).expect("due may now be removed");
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn an_unrelated_edit_is_unaffected_by_the_rule() {
        // A task with no due date and no recurrence must still be editable.
        let (tmp, path, uuid) = fixture(None);
        update(&path, &uuid, &[("description", "renamed")]).expect("plain edit");
        assert_eq!(field(&path, &uuid, "description").as_deref(), Some("renamed"));
        fs::remove_dir_all(&tmp).ok();
    }
}

#[cfg(test)]
mod recurring_status_tests {
    use super::*;
    use serde_json::Value;
    use std::{collections::HashMap, env, fs};

    /// The `recurring` status must be settable.
    ///
    /// It previously fell into update_task's catch-all and was silently
    /// downgraded to Pending, which meant the app could not create a recurrence
    /// template at all: the Taskwarrior CLI only generates instances for a task
    /// whose status is `recurring`, so with `recur` alone nothing ever happened.
    #[test]
    fn recurring_status_round_trips() {
        let tmp = env::temp_dir().join(format!("taskdb_recstat_{}", Uuid::new_v4()));
        fs::create_dir_all(&tmp).unwrap();
        let path = tmp.to_string_lossy().into_owned();

        let uuid = Uuid::new_v4().to_string();
        let mut add: HashMap<String, String> = HashMap::new();
        add.insert("uuid".into(), uuid.clone());
        add.insert("description".into(), "template".into());
        add.insert("due".into(), "2026-09-01T09:00:00Z".into());
        add_task(path.clone(), add).unwrap();

        let mut upd: HashMap<String, String> = HashMap::new();
        upd.insert("recur".into(), "weekly".into());
        upd.insert("status".into(), "recurring".into());
        update_task(uuid.clone(), path.clone(), upd).unwrap();

        let json = get_all_tasks_json(path.clone()).unwrap();
        let tasks: Vec<Value> = serde_json::from_str(&json).unwrap();
        let t = tasks
            .into_iter()
            .find(|t| t["uuid"].as_str() == Some(uuid.as_str()))
            .unwrap();

        assert_eq!(t["status"].as_str(), Some("recurring"), "status must stick");
        assert_eq!(t["recur"].as_str(), Some("weekly"));

        fs::remove_dir_all(&tmp).ok();
    }
}

#[cfg(test)]
mod status_validation_tests {
    use super::*;
    use serde_json::Value;
    use std::{collections::HashMap, env, fs};

    /// An unrecognised status must be refused, not quietly turned into Pending.
    ///
    /// The old catch-all did the latter, which is how "recurring" was accepted
    /// by the caller and silently discarded — the app could not create a
    /// recurrence template and nothing said why.
    #[test]
    fn unknown_status_is_refused_not_coerced() {
        let tmp = env::temp_dir().join(format!("taskdb_st_{}", Uuid::new_v4()));
        fs::create_dir_all(&tmp).unwrap();
        let path = tmp.to_string_lossy().into_owned();

        let uuid = Uuid::new_v4().to_string();
        let mut add: HashMap<String, String> = HashMap::new();
        add.insert("uuid".into(), uuid.clone());
        add.insert("description".into(), "t".into());
        add_task(path.clone(), add).unwrap();

        // put it in a non-default state so a silent coercion would be visible
        let mut done: HashMap<String, String> = HashMap::new();
        done.insert("status".into(), "completed".into());
        update_task(uuid.clone(), path.clone(), done).unwrap();

        let mut bogus: HashMap<String, String> = HashMap::new();
        bogus.insert("status".into(), "waiting".into());
        let err = update_task(uuid.clone(), path.clone(), bogus)
            .expect_err("an unknown status must be refused");
        assert!(err.contains("unknown status"), "unhelpful: {err}");

        // and the refusal must not have changed anything
        let json = get_all_tasks_json(path.clone()).unwrap();
        let tasks: Vec<Value> = serde_json::from_str(&json).unwrap();
        let t = tasks
            .into_iter()
            .find(|t| t["uuid"].as_str() == Some(uuid.as_str()))
            .unwrap();
        assert_eq!(t["status"].as_str(), Some("completed"));

        fs::remove_dir_all(&tmp).ok();
    }
}

#[cfg(test)]
mod add_task_attribute_tests {
    //! `add_task` and `update_task` are handed the same key set — Replica.attrs
    //! on the Dart side drives both — but add_task only implemented seven of the
    //! nine, dropping the other two into a catch-all that returned success.
    //! These pin the two entry points to the same contract.
    use super::*;
    use serde_json::Value;
    use std::{collections::HashMap, env, fs};

    fn dir() -> (std::path::PathBuf, String) {
        let tmp = env::temp_dir().join(format!("taskdb_addattr_{}", Uuid::new_v4()));
        fs::create_dir_all(&tmp).expect("create temp taskdb dir");
        let path = tmp.to_string_lossy().into_owned();
        (tmp, path)
    }

    fn add(path: &str, pairs: &[(&str, &str)]) -> (String, Result<(), String>) {
        let uuid = Uuid::new_v4().to_string();
        let mut map: HashMap<String, String> = pairs
            .iter()
            .map(|(k, v)| (k.to_string(), v.to_string()))
            .collect();
        map.insert("uuid".to_string(), uuid.clone());
        map.entry("description".to_string())
            .or_insert_with(|| "chore".to_string());
        let res = add_task(path.to_string(), map);
        (uuid, res)
    }

    fn field(path: &str, uuid: &str, key: &str) -> Option<String> {
        let json = get_all_tasks_json(path.to_string()).expect("get_all_tasks_json");
        let tasks: Vec<Value> = serde_json::from_str(&json).expect("parse json");
        tasks
            .into_iter()
            .find(|t| t.get("uuid").and_then(|u| u.as_str()) == Some(uuid))
            .and_then(|t| t.get(key).and_then(|v| v.as_str()).map(|s| s.to_string()))
    }

    fn exists(path: &str, uuid: &str) -> bool {
        field(path, uuid, "uuid").is_some()
    }

    #[test]
    fn status_supplied_at_creation_is_honoured() {
        let (tmp, path) = dir();
        // add_task sets Pending before applying the map; an explicit status has
        // to win over that default rather than be discarded by the catch-all.
        let (uuid, res) = add(&path, &[("status", "completed")]);
        res.expect("add_task");

        assert_eq!(field(&path, &uuid, "status").as_deref(), Some("completed"));
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn recur_supplied_at_creation_is_stored() {
        let (tmp, path) = dir();
        let (uuid, res) = add(
            &path,
            &[
                ("recur", "weekly"),
                ("due", "2026-09-01T09:00:00Z"),
                ("status", "recurring"),
            ],
        );
        res.expect("add_task");

        assert_eq!(field(&path, &uuid, "recur").as_deref(), Some("weekly"));
        assert_eq!(field(&path, &uuid, "status").as_deref(), Some("recurring"));
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn recur_without_a_due_date_is_refused_at_creation() {
        let (tmp, path) = dir();
        // update_task already refuses this. Creation had no such check, so the
        // same task the editor cannot produce could be created outright — and
        // the CLI deletes it on the next run.
        let (uuid, res) = add(&path, &[("recur", "weekly")]);

        let err = res.expect_err("must be refused");
        assert!(err.contains("needs a due date"), "unhelpful: {err}");
        assert!(!exists(&path, &uuid), "nothing should have been created");
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn unknown_status_is_refused_at_creation() {
        let (tmp, path) = dir();
        let (uuid, res) = add(&path, &[("status", "archived")]);

        let err = res.expect_err("must be refused");
        assert!(err.contains("unknown status 'archived'"), "unhelpful: {err}");
        assert!(!exists(&path, &uuid), "nothing should have been created");
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn an_attribute_neither_side_agrees_on_is_refused() {
        let (tmp, path) = dir();
        // The failure this guards against is silent drift: Dart grows an entry
        // in attrs, Rust does not, and the write reports success either way.
        let (uuid, res) = add(&path, &[("energy", "high")]);

        let err = res.expect_err("must be refused");
        assert!(err.contains("unknown attribute 'energy'"), "unhelpful: {err}");
        assert!(!exists(&path, &uuid), "nothing should have been created");
        fs::remove_dir_all(&tmp).ok();
    }

    #[test]
    fn every_attribute_the_dart_side_can_send_is_accepted() {
        let (tmp, path) = dir();
        // Mirrors Replica.attrs plus the two keys the Dart layer adds itself.
        // If this fails, the catch-all above will be rejecting a real write.
        let (uuid, res) = add(
            &path,
            &[
                ("description", "full sweep"),
                ("due", "2026-09-01T09:00:00Z"),
                ("start", "2026-08-01T09:00:00Z"),
                ("wait", "2026-08-20T09:00:00Z"),
                ("priority", "H"),
                ("project", "home"),
                ("status", "recurring"),
                ("recur", "monthly"),
                ("tags", "one two"),
            ],
        );
        res.expect("every declared attribute must be accepted");

        assert_eq!(field(&path, &uuid, "description").as_deref(), Some("full sweep"));
        assert_eq!(field(&path, &uuid, "project").as_deref(), Some("home"));
        assert_eq!(field(&path, &uuid, "recur").as_deref(), Some("monthly"));
        fs::remove_dir_all(&tmp).ok();
    }
}
