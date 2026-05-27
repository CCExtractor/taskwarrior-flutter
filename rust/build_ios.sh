#!/usr/bin/env bash
# Build tc_helper.xcframework for iOS (device + simulator) and place it at
# ios/tc_helper.xcframework.
#
# Requires the Xcode command-line tools and the iOS Rust targets:
#   rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios
set -euo pipefail

cd "$(dirname "$0")"

LIB_NAME="tc_helper"
FRAMEWORK="${LIB_NAME}.framework"
MIN_IOS="13.0"
BUNDLE_ID="com.ccextractor.taskwarriorflutter.tc-helper"

BUILD_DIR="target/ios-framework"
DEVICE_FW="${BUILD_DIR}/device/${FRAMEWORK}"
SIM_FW="${BUILD_DIR}/sim/${FRAMEWORK}"
OUTPUT="../ios/${LIB_NAME}.xcframework"

# 1. Compile the cdylib for each iOS target.
cargo build --release --target aarch64-apple-ios
cargo build --release --target aarch64-apple-ios-sim
cargo build --release --target x86_64-apple-ios

# 2. Lay out one .framework per slice; the simulator slice is a fat
#    (arm64 + x86_64) binary built with lipo.
rm -rf "${BUILD_DIR}"
mkdir -p "${DEVICE_FW}" "${SIM_FW}"

cp "target/aarch64-apple-ios/release/lib${LIB_NAME}.dylib" "${DEVICE_FW}/${LIB_NAME}"
lipo -create \
  "target/aarch64-apple-ios-sim/release/lib${LIB_NAME}.dylib" \
  "target/x86_64-apple-ios/release/lib${LIB_NAME}.dylib" \
  -output "${SIM_FW}/${LIB_NAME}"

# 3. Set the install name to an @rpath relative to the framework, and write the
#    framework Info.plist for each slice.
write_plist() {
  cat > "$1/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${LIB_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>MinimumOSVersion</key>
    <string>${MIN_IOS}</string>
</dict>
</plist>
PLIST
}

for FW in "${DEVICE_FW}" "${SIM_FW}"; do
  install_name_tool -id "@rpath/${FRAMEWORK}/${LIB_NAME}" "${FW}/${LIB_NAME}"
  write_plist "${FW}"
done

# 4. Assemble the xcframework.
rm -rf "${OUTPUT}"
xcodebuild -create-xcframework \
  -framework "${DEVICE_FW}" \
  -framework "${SIM_FW}" \
  -output "${OUTPUT}"

echo "Built ${OUTPUT}"
