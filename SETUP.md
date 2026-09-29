# Local Setup

This guide walks you through running **taskwarrior-flutter** on your machine.

The project is a Flutter app that talks to a Rust native library
(`tc_helper`, built with [`flutter_rust_bridge`](https://cjycode.com/flutter_rust_bridge/))
for TaskChampion storage and sync. You do **not** need Rust to run the app:
prebuilt native libraries are committed to the repo, and the build hooks that
would rebuild them are deliberately non-fatal. Rust is only needed if you want
to change the native code yourself (see [Working with Rust](#working-with-rust-optional)).

---

## 1. Prerequisites

| Tool | Version / notes |
| --- | --- |
| [Git](https://git-scm.com/) | Any recent version |
| [FVM](https://fvm.app/) | Flutter Version Management. Pins the SDK for this repo |
| Flutter SDK | **3.44.9** (installed automatically by FVM from `.fvmrc`) |
| Java JDK | **17** (required by the Android Gradle plugin). On Apple Silicon use the **arm64/aarch64** build, not an x86_64 one |
| Android Studio | Android SDK plus an emulator or a physical device |
| Xcode | iOS / macOS builds (full Xcode, not just Command Line Tools) |
| Rust (optional) | Only for rebuilding the native `libtc_helper`; see below |

> **Do not install a global Flutter version and use it directly.** This repo
> pins Flutter **3.44.9** in `.fvmrc`. Building with a different SDK is the
> most common cause of confusing failures. Always go through `fvm flutter`.

---

## 2. Install FVM and the pinned Flutter SDK

If you don't already have FVM, install it once:

```bash
# macOS / Linux (Dart is bundled with Flutter; if you have Flutter already)
dart pub global activate fvm

# Homebrew alternative
brew tap leoafarias/fvm && brew install fvm
```

Make sure your shell can find it (add to `~/.zshrc` or `~/.bashrc` if needed):

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

Now let FVM read `.fvmrc` and install/pin the correct SDK:

```bash
# from the repo root
fvm install          # downloads Flutter 3.44.9 as pinned in .fvmrc
fvm use 3.44.9       # creates the .fvm/flutter_sdk symlink
```

Verify:

```bash
fvm flutter --version   # should report 3.44.9
fvm flutter doctor      # resolve anything flagged for your target platform(s)
```

---

## 3. Clone and install dependencies

```bash
git clone https://github.com/CCExtractor/taskwarrior-flutter.git
cd taskwarrior-flutter

fvm install
fvm flutter pub get
```

---

## 4. Run the app

The app ships two Android **flavors**:

| Flavor | Application ID | Purpose |
| --- | --- | --- |
| `production` | `com.ccextractor.taskwarriorflutter` | The normal app. Use this for day-to-day development |
| `nightly` | `com.ccextractor.taskwarriorflutter.nightly` | CI-only build; harmless to run locally |

```bash
# Development (hot reload)
fvm flutter run --flavor production

# Nightly flavor
fvm flutter run --flavor nightly
```

If no device is listed, run `fvm flutter devices` and start an emulator/simulator
or connect a device first.

> **A flavor is required for Android builds.** Running a bare `fvm flutter run`
> without `--flavor` fails because `android/app/build.gradle` defines flavors
> and no default one.

### VS Code

The repo ships run configurations in `.vscode/launch.json` for
production/nightly in debug, profile, and release modes. They already point at
`.fvm/flutter_sdk`, so just open the **Run and Debug** panel and pick one.
(`.vscode/settings.json` is git-ignored, so create it if you need custom
settings. The tracked `.vscode/launch.json` is the important part.)

---

## 5. Working with Rust (optional)

You only need this section if you are **changing the native code** under
`rust/`. For ordinary Dart/Flutter work you can skip it entirely.

### How the native library is provided

- **Android**: `android/app/build.gradle` registers a `cargoBuildTcHelper` task.
  On every build it looks for `cargo` and `cargo-ndk`:
  - If found, it cross-compiles `rust/` into
    `android/app/src/main/jniLibs/<abi>/libtc_helper.so`.
  - If **not** found, it prints a notice and falls back to the committed
    `.so` files in `android/app/src/main/jniLibs/`.
- **iOS / macOS**: a CocoaPods `script_phase` (see `ios/Podfile` and
  `macos/Podfile`) calls `scripts/build_tc_helper_apple.sh`. It rebuilds the
  library when the toolchain exists and silently keeps the existing binary
  otherwise. On macOS it writes `rust/target/release/libtc_helper.dylib`; on
  iOS it rebuilds `ios/tc_helper.xcframework`.

Both hooks are **non-fatal by design**, so a contributor without Rust can still
build and run.

### Toolchain (only if you want to rebuild)

```bash
# Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# cargo-ndk (for Android cross-compilation)
cargo install cargo-ndk --version '^4' --locked

# Android NDK. Must match CI: 26.1.10909125
sdkmanager "ndk;26.1.10909125"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/26.1.10909125"

# Rust targets used by the project
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
# iOS only:
rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios
```

### Rebuild the library

```bash
cd rust
cargo ndk -t arm64-v8a -t armeabi-v7a -t x86_64 \
  -o ../android/app/src/main/jniLibs build --release
```

The three ABIs (`arm64-v8a`, `armeabi-v7a`, `x86_64`) must match the `-t` flags
in `android/app/build.gradle` and the list in
`.github/actions/setup-rust-android/action.yml`. If you add one, update all three.

### Regenerating the Dart / Rust bindings

When you change the public Rust API (`rust/src/api.rs`), the generated bindings
must be refreshed. The easiest way is the opt-in hook in `rust/build.rs`:

```bash
cd rust
FRB_CODEGEN=1 cargo build     # regenerates ../lib/rust_bridge
```

Or run the code generator directly:

```bash
flutter_rust_bridge_codegen generate \
  --rust-input crate::api \
  --rust-root rust \
  --dart-output lib/rust_bridge
```

> `flutter_rust_bridge_codegen` must be the **2.11.1** version to match the
> `flutter_rust_bridge` dependency in `rust/Cargo.toml` and `pubspec.yaml`.
> `cargo install flutter_rust_bridge_codegen --version 2.11.1`.

---

## 6. Everyday commands

```bash
# Static analysis (same flags CI uses)
fvm flutter analyze --no-fatal-warnings --no-fatal-infos

# Tests
fvm flutter test

# Release APK (production)
fvm flutter build apk --release --flavor production

# Verify the APK actually contains the native library for every ABI
./scripts/verify_apk_native_libs.sh \
  build/app/outputs/flutter-apk/app-production-release.apk
```

The verification step matters: an APK missing `libtc_helper.so` installs and
launches fine, then crashes inside `RustLib.init()`. CI fails the build if it's
missing.

---

## 7. Files you should not edit

Some files are **generated** or are **build outputs**. Hand-editing them will be
overwritten, or will silently drift from the source of truth. Change the source
and regenerate instead.

### Do not edit: generated by `flutter_rust_bridge`

These are regenerated from `rust/src/api.rs`:

- `rust/src/frb_generated.rs`
- `lib/rust_bridge/frb_generated.dart`
- `lib/rust_bridge/frb_generated.io.dart`
- `lib/rust_bridge/frb_generated.web.dart`
- `lib/rust_bridge/api.dart`

Edit the Rust source (`rust/src/api.rs` and friends), then regenerate bindings
(Section 5). Every one of these files carries a
`// This file is automatically generated ... do not edit` header.

### Do not edit: generated by `flutter_gen`

- `lib/app/utils/gen/assets.gen.dart`
- `lib/app/utils/gen/fonts.gen.dart`

These come from the assets/fonts declared in `pubspec.yaml`. Add the asset to
`pubspec.yaml`, then regenerate (they are produced by the `flutter_gen_runner`
build):

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Do not hand-edit: build outputs / binaries

- `android/app/src/main/jniLibs/<abi>/libtc_helper.so` (compiled from `rust/`)
- `ios/tc_helper.xcframework/` (compiled from `rust/`)
- `rust/target/` (Cargo build directory)
- `build/` (Flutter build output)

### Do not edit manually: Flutter-managed

- `.metadata` (managed by the Flutter tool)
- `.fvm/`, `.dart_tool/`, `.flutter-plugins*` (caches; safe to delete and
  regenerate, never to edit)
- `pubspec.lock` (commit it, but change it through `flutter pub`, not by hand)

### Where Rust changes *should* go

Work in `rust/src/api.rs`, `rust/src/storage.rs`, `rust/src/serialize.rs`,
`rust/src/utils/`, and `rust/Cargo.toml`. Then run the native build and, if the
API changed, the binding regeneration from Section 5.

---

## 8. Troubleshooting

| Symptom | Fix |
| --- | --- |
| `flutter` resolves to the wrong version | Use `fvm flutter ...`, or run `fvm use 3.44.9` to refresh the symlink |
| Android build fails with a Java/AGP error | Make sure JDK **17** is active (`java -version`) |
| `Bad CPU type in executable` pointing at `.../bin/java` | You have an x86_64 JDK on an Apple Silicon Mac. Install an arm64 JDK 17 (e.g. `brew install --cask temurin@17`) and point Flutter at it: `fvm flutter config --jdk-dir="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"` |
| `--flavor` missing error | Pass `--flavor production` or `--flavor nightly` |
| App crashes immediately in `RustLib.init()` | The native library wasn't packaged. Rebuild it (Section 5) or run `scripts/verify_apk_native_libs.sh` against the APK |
| `cargo`/`cargo-ndk not found` notice during build | Expected without Rust; the committed `.so` is used. Install the toolchain only if you need to rebuild |
| `flutter_rust_bridge_codegen` version mismatch | Install exactly `2.11.1` |
| `[CXX1101] NDK ... did not have a source.properties file` | A partial/failed NDK download. Delete the folder under `$ANDROID_HOME/ndk/<version>` and reinstall it with `sdkmanager "ndk;26.1.10909125"`. If you are not building Rust, removing the broken folder lets the build fall back to the committed native libraries |
| iOS build can't find `tc_helper.xcframework` | Full Xcode required; open it once and run `xcodebuild -runFirstLaunch` |

---

## 9. Related docs

- [README.md](README.md): project overview and syncing setup
- [CONTRIBUTING.md](CONTRIBUTING.md): contribution workflow
- [rust/README.md](rust/README.md): Rust and Flutter command reference
- [docs/Architecture.md](docs/Architecture.md): GetX module structure
