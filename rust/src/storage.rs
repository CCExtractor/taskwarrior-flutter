use std::path::PathBuf;
use taskchampion::{Replica, StorageConfig};

use crate::utils::error::TcHelperError;

/// Open (creating if necessary) the on-disk TaskChampion replica at
/// `taskdb_dir_path` in read/write mode.
///
/// This centralises the storage-configuration boilerplate that was previously
/// duplicated across every FFI entry point.
pub fn open_replica(taskdb_dir_path: &str) -> Result<Replica, TcHelperError> {
    let taskdb_dir = PathBuf::from(taskdb_dir_path);
    let storage = StorageConfig::OnDisk {
        taskdb_dir,
        create_if_missing: true,
        access_mode: taskchampion::storage::AccessMode::ReadWrite,
    }
    .into_storage()
    .map_err(|e| TcHelperError::ReplicaOpen {
        path: taskdb_dir_path.to_string(),
        message: e.to_string(),
    })?;

    Ok(Replica::new(storage))
}
