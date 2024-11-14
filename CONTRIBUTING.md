<!-- CONTRIBUTING -->

<!-- GETTING STARTED -->

# Getting Started

In order to use the mobile app, you would need the flood backend running on your local machine. There are several ways
you can do that and all these approaches can be found at [TaskWarrior-Flutter](https://github.com/CCExtractor/taskwarrior-flutter/wiki)


## Steps

### Installation 
1. Clone the repository from GitHub:

```bash
git clone https://github.com/CCExtractor/taskwarrior-flutter.git taskwarrior_flutter
```

2. Navigate to project's root directory:

```bash
cd taskwarrior_flutter
```

3. Check for Flutter setup and connected devices:

```bash
flutter doctor
```

4. Get the dependancies

```bash
flutter pub get
```

%. Run the app:

```bash
flutter run
```

### Check out the app
___


1. Open mobile app
   1. Check out the app
   2. Make Profile
   3. Connect with TaskServer
   4. Sync Tasks with it


## Prerequisites

* Flutter
* VSCode / Android Studio

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
2. Create your Fix Branch (`git checkout -b fix/BugFix`)
3. Add all files(`git add .`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request in the **develop branch**

### Common Issues to Note
- Linux Compatibility Error
If you encounter the following error when building the app on Linux, it is related to a missing type `UnmodifiableUint8ListView`. This issue can often occur during the build process:
```sh
Building package executables... (5.4s)
Failed to build get_cli:get:
../../../.pub-cache/hosted/pub.dev/win32-5.3.0/lib/src/guid.dart:32:9: Error: Type 'UnmodifiableUint8ListView' not found.
  final UnmodifiableUint8ListView bytes;
        ^^^^^^^^^^^^^^^^^^^^^^^^^
```
solution:
```sh
flutter pub cache clean
flutter channel stable
flutter pub get
```
follow this thread for the discussion on it: [solution](https://github.com/jonataslaw/get_cli/issues/263)

- Android Debug Naming Format Issue
Flutter does not support repository names with dashes when setting up Android debug mode. To avoid errors, clone the repository using an underscore in the name:
```sh
git clone https://github.com/CCExtractor/taskwarrior-flutter taskwarrior_flutter
```