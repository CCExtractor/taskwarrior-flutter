#!/usr/bin/env bash
# Build the tc_helper native libraries for Android and place them in
# android/app/src/main/jniLibs/.
#
# Requires cargo-ndk (https://github.com/bbqsrc/cargo-ndk) and the Android NDK.
#   cargo install cargo-ndk
set -euo pipefail

cd "$(dirname "$0")"

cargo ndk \
  -t arm64-v8a \
  -t armeabi-v7a \
  -o ../android/app/src/main/jniLibs \
  build --release

echo "Built native libraries in android/app/src/main/jniLibs/"
