`For dart file generation`  
`flutter_rust_bridge_codegen generate \`  
  `--rust-input crate::api \`  
  `--rust-root rust \`  
  `--dart-output lib/bridge/bridge_generated.dart`

`For Compiling RustLib to android`  
`cargo ndk -t arm64-v8a -t armeabi-v7a -t x86 -t x86_64 -o ../android/main/app/src/main/jniLibs build`

- [ ] `these targets are not added yet`

`For running application`  
`[fvm] flutter run –flavor {production/nightly}`

`For Compiling/Building apk`  
`[fvm] flutter build apk –-flavor production`

* `Nightly is only for CI`