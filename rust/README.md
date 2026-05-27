## Rust ⇄ Flutter: Commands

> **Note:** The compiled native libraries are **not** checked into git. They are
> build outputs that must be generated locally before building the app:
>
> - Android: `android/app/src/main/jniLibs/` (`.so` files)
> - iOS: `ios/tc_helper.xcframework/`
>
> Both directories are git-ignored. Use the commands below (or the helper
> scripts `rust/build_android.sh` and `rust/build_ios.sh`) to produce them.

### Generate Dart bindings

```bash
flutter_rust_bridge_codegen generate \
  --rust-input crate::api \
  --rust-root rust \
  --dart-output lib/bridge/bridge_generated.dart
```

### Compile Rust library for Android

Requires [`cargo-ndk`](https://github.com/bbqsrc/cargo-ndk) and the Android NDK.

```bash
cargo ndk -t arm64-v8a -t armeabi-v7a -o ../android/app/src/main/jniLibs build --release
```

Or run the helper script from the `rust/` directory:

```bash
./build_android.sh
```

### Compile Rust library for iOS

Requires the Apple iOS Rust targets and Xcode command-line tools:

```bash
rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios
```

Build the `tc_helper.xcframework` (device + simulator slices) with the helper
script from the `rust/` directory:

```bash
./build_ios.sh
```

This produces `ios/tc_helper.xcframework`, which the Xcode project embeds as a
framework.

### Run the app

```bash
# using fvm
fvm flutter run --flavor {production|nightly}
```

### Build APK

```bash
# using fvm
fvm flutter build apk --flavor production
```

Note: Nightly is only for CI.
