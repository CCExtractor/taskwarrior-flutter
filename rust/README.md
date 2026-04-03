## Rust ⇄ Flutter: Commands

### Generate Dart bindings

```bash
flutter_rust_bridge_codegen generate \
  --rust-input crate::api \
  --rust-root rust \
  --dart-output lib/bridge/bridge_generated.dart
```

### Native Library Compilation

#### 🚀 Desktop (Linux, Windows, macOS)

The native library is now **automatically compiled** for Desktop platforms when you run the app. No manual cargo build is required.

#### 📱 Android
Android still requires manual compilation of JNI libraries:

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
