use serde_json::{json, Value};
use taskchampion::Task;

/// Serialise a TaskChampion [`Task`] into the JSON object the Flutter layer
/// consumes.
///
/// Beyond the flat properties the previous serialiser emitted, this now
/// surfaces attributes the Dart model already anticipated but never received:
///
/// * `tags`        — space-joined user tags (synthetic tags are excluded)
/// * `annotations` — array of `{ entry, description }` objects
/// * `depends`     — array of dependency UUID strings
/// * `is_blocked`  — whether the task has at least one unresolved dependency
/// * `is_blocking` — whether at least one other task depends on this one
/// * `recur`       — recurrence rule, when present
///
/// `urgency` is intentionally omitted: TaskChampion 2.0.3 does not compute or
/// store an urgency value on [`Task`], so there is nothing authoritative to
/// surface here.
#[allow(deprecated)] // `get_taskmap` is deprecated upstream; retained for the raw property view.
pub fn task_to_json(task: &Task) -> Value {
    let mut map = serde_json::Map::new();
    let mut tags: Vec<String> = Vec::new();

    for (key, value) in task.get_taskmap() {
        if let Some(tag) = key.strip_prefix("tag_") {
            // User tags are stored as `tag_<name>` properties.
            tags.push(tag.to_string());
        } else if key.starts_with("dep_") || key.starts_with("annotation_") {
            // Raw dependency/annotation properties are surfaced below as
            // structured arrays, so skip their flat representation here.
            continue;
        } else {
            // Flat properties (description, status, due, priority, project,
            // recur, ...) pass straight through as strings.
            map.insert(key.clone(), Value::String(value.clone()));
        }
    }

    let annotations: Vec<Value> = task
        .get_annotations()
        .map(|a| {
            json!({
                // RFC 3339 / ISO-8601 so consumers get an unambiguous,
                // directly-parseable timestamp (not a bare epoch number).
                "entry": a.entry.to_rfc3339(),
                "description": a.description,
            })
        })
        .collect();

    let depends: Vec<Value> = task
        .get_dependencies()
        .map(|uuid| Value::String(uuid.to_string()))
        .collect();

    map.insert("uuid".into(), Value::String(task.get_uuid().to_string()));
    map.insert("tags".into(), Value::String(tags.join(" ")));
    map.insert("annotations".into(), Value::Array(annotations));
    map.insert("depends".into(), Value::Array(depends));
    map.insert("is_blocked".into(), Value::Bool(task.is_blocked()));
    map.insert("is_blocking".into(), Value::Bool(task.is_blocking()));
    // `recur` is already carried through the flat-property loop above.

    Value::Object(map)
}
