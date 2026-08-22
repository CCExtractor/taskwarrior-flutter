use std::env;
use std::process::Command;

/// Build script for `tc_helper`.
///
/// * Rebuilds whenever anything under `src/` changes so the FFI stays in sync.
/// * Detects the target platform and exposes it as a build-time note.
/// * Optionally regenerates the flutter_rust_bridge bindings when the
///   `FRB_CODEGEN=1` environment variable is set, so contributors can refresh
///   bindings from a plain `cargo build` without memorising the CLI flags.
///   (It is opt-in so ordinary/CI builds never shell out to the codegen tool.)
fn main() {
    println!("cargo:rerun-if-changed=src/");
    println!("cargo:rerun-if-env-changed=FRB_CODEGEN");

    let target = env::var("TARGET").unwrap_or_default();
    let platform = if target.contains("android") {
        "android"
    } else if target.contains("apple-ios") {
        "ios"
    } else if target.contains("apple-darwin") {
        "macos"
    } else if target.contains("linux") {
        "linux"
    } else if target.contains("windows") {
        "windows"
    } else {
        "unknown"
    };
    // Expose the detected platform as a compile-time env var (readable via
    // env!("TC_HELPER_PLATFORM")) instead of a per-build warning, so ordinary
    // builds stay quiet.
    println!("cargo:rustc-env=TC_HELPER_PLATFORM={platform}");

    if env::var("FRB_CODEGEN").as_deref() == Ok("1") {
        let status = Command::new("flutter_rust_bridge_codegen")
            .args([
                "generate",
                "--rust-input",
                "crate::api",
                "--rust-root",
                ".",
                "--dart-output",
                "../lib/rust_bridge",
            ])
            .status();
        match status {
            Ok(s) if s.success() => println!("cargo:warning=flutter_rust_bridge bindings regenerated"),
            Ok(s) => println!("cargo:warning=flutter_rust_bridge_codegen exited with {s}"),
            Err(e) => println!("cargo:warning=could not run flutter_rust_bridge_codegen: {e}"),
        }
    }
}
