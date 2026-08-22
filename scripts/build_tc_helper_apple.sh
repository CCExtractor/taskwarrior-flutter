#!/usr/bin/env bash
#
# Compiles the tc_helper Rust library for Apple platforms during a Flutter
# build, so the native library always matches rust/ instead of relying on a
# checked-in binary.
#
# Invoked from a CocoaPods script_phase (see ios/Podfile and macos/Podfile).
#
#   ./build_tc_helper_apple.sh ios     -> rebuilds ios/tc_helper.xcframework
#                                         (device arm64 + simulator fat)
#   ./build_tc_helper_apple.sh macos   -> builds rust/target/release/, which is
#                                         where flutter_rust_bridge's desktop
#                                         loader looks (ioDirectory in
#                                         frb_generated.dart)
#
# DELIBERATELY NON-FATAL: if the Rust toolchain (or a required target) is
# missing, this warns and exits 0 so the build carries on with whatever library
# is already present. A contributor without Rust installed must still be able
# to build the app; this only *upgrades* the build when the toolchain is there.
set -uo pipefail

PLATFORM="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RUST_DIR="${REPO_ROOT}/rust"

warn() { echo "warning: [tc_helper] $*" >&2; }

if [ ! -d "${RUST_DIR}" ]; then
  warn "no rust/ directory at ${RUST_DIR}; skipping native rebuild"
  exit 0
fi

# Xcode's build environment does not inherit a login shell, so cargo installed
# via rustup is typically not on PATH here.
export PATH="${HOME}/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}"

if ! command -v cargo >/dev/null 2>&1; then
  warn "cargo not found on PATH; skipping native rebuild (using the existing binary)"
  exit 0
fi

ensure_target() {
  local target="$1"
  if command -v rustup >/dev/null 2>&1; then
    rustup target add "${target}" >/dev/null 2>&1 || true
  fi
}

cd "${RUST_DIR}" || { warn "cannot enter ${RUST_DIR}"; exit 0; }

case "${PLATFORM}" in
  macos)
    # The desktop loader reads rust/target/release/libtc_helper.dylib.
    if ! cargo build --release; then
      warn "cargo build failed; leaving any existing library in place"
      exit 0
    fi
    echo "[tc_helper] built rust/target/release for macOS"
    ;;

  ios)
    OUT_FRAMEWORK="${REPO_ROOT}/ios/tc_helper.xcframework"

    if ! command -v xcodebuild >/dev/null 2>&1 \
       || ! xcodebuild -version >/dev/null 2>&1; then
      warn "xcodebuild unavailable (full Xcode required); keeping existing xcframework"
      exit 0
    fi

    ensure_target aarch64-apple-ios
    ensure_target aarch64-apple-ios-sim
    ensure_target x86_64-apple-ios

    if ! cargo build --release --target aarch64-apple-ios; then
      warn "device build failed; keeping existing xcframework"
      exit 0
    fi

    # The simulator slice must cover both Apple-silicon and Intel hosts.
    SIM_LIBS=()
    if cargo build --release --target aarch64-apple-ios-sim; then
      SIM_LIBS+=("target/aarch64-apple-ios-sim/release/libtc_helper.a")
    fi
    if cargo build --release --target x86_64-apple-ios; then
      SIM_LIBS+=("target/x86_64-apple-ios/release/libtc_helper.a")
    fi
    if [ ${#SIM_LIBS[@]} -eq 0 ]; then
      warn "no simulator slice built; keeping existing xcframework"
      exit 0
    fi

    SIM_FAT="target/libtc_helper_sim.a"
    if ! lipo -create "${SIM_LIBS[@]}" -output "${SIM_FAT}"; then
      warn "lipo failed; keeping existing xcframework"
      exit 0
    fi

    # -create-xcframework refuses to overwrite an existing bundle.
    TMP_FRAMEWORK="${REPO_ROOT}/ios/.tc_helper.xcframework.new"
    rm -rf "${TMP_FRAMEWORK}"
    if ! xcodebuild -create-xcframework \
        -library "target/aarch64-apple-ios/release/libtc_helper.a" \
        -library "${SIM_FAT}" \
        -output "${TMP_FRAMEWORK}"; then
      warn "create-xcframework failed; keeping existing xcframework"
      rm -rf "${TMP_FRAMEWORK}"
      exit 0
    fi

    # Swap in only once the new bundle is known-good, so a failure part-way
    # through can never leave the project without a linkable framework.
    rm -rf "${OUT_FRAMEWORK}"
    mv "${TMP_FRAMEWORK}" "${OUT_FRAMEWORK}"
    echo "[tc_helper] rebuilt ${OUT_FRAMEWORK}"
    ;;

  *)
    warn "unknown platform '${PLATFORM}' (expected ios|macos); skipping"
    ;;
esac

exit 0
