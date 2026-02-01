## Rust ⇄ Flutter: Commands

### Generate Dart bindings

```bash
flutter_rust_bridge_codegen generate \
  --rust-input crate::api \
  --rust-root rust \
  --dart-output lib/bridge/bridge_generated.dart
```

### Compile Rust library for Android

```bash
cargo ndk -t arm64-v8a -t armeabi-v7a -o ../android/app/src/main/jniLibs build --release
```

- [ ] these targets are not added yet

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
