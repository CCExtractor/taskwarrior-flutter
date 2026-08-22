use thiserror::Error;

/// Errors raised by the `tc_helper` FFI layer.
///
/// Each FFI entry point in [`crate::api`] converts one of these into a plain
/// error string, which flutter_rust_bridge surfaces to the Dart side as a
/// thrown exception. Modelling the failure modes as a typed enum keeps the
/// Rust code free of `.unwrap()` panics and makes the source of a failure
/// explicit at the call site.
#[derive(Error, Debug)]
pub enum TcHelperError {
    #[error("cannot open replica at '{path}': {message}")]
    ReplicaOpen { path: String, message: String },

    #[error("invalid UUID '{0}'")]
    InvalidUuid(String),

    #[error("no task with UUID '{0}'")]
    TaskNotFound(String),

    #[error("invalid input: {0}")]
    InvalidInput(String),

    #[error("sync failed: {0}")]
    Sync(String),

    #[error("task operation failed: {0}")]
    Commit(String),

    #[error("taskchampion error: {0}")]
    Champion(String),

    #[error("JSON serialization error: {0}")]
    Serialization(#[from] serde_json::Error),
}
