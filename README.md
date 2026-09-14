<p align="center">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/1ffb623b-b147-4176-9f7c-abda544b257c" alt="Taskwarrior Mobile App" width="720">
</p>

<h1 align="center">Taskwarrior Mobile App</h1>

<p align="center">
  A cross-platform Flutter client for <a href="https://taskwarrior.org/">Taskwarrior</a>.
</p>

<p align="center">
  <a href="https://slackinvite.ccextractor.org/"><img src="https://img.shields.io/badge/chat-on%20slack-purple.svg?style=for-the-badge&logo=slack" alt="Slack"></a>
  <img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge" alt="License: GPL v3">
  <img src="https://img.shields.io/badge/Flutter-3.44.9-02569B.svg?style=for-the-badge&logo=flutter" alt="Flutter">
</p>

---

## Table of Contents

- [About](#about)
- [Screenshots](#screenshots)
- [Built With](#built-with)
- [Getting Started](#getting-started)
- [Syncing](#syncing)
  - [TaskChampion (recommended)](#taskchampion-recommended)
  - [Legacy TaskServer](#legacy-taskserver)
- [Contributing](#contributing)
- [Community](#community)
- [Project Timeline](#project-timeline)
- [License](#license)
- [Contact](#contact)

---

## About

Taskwarrior is free and open-source software that manages your TODO list from the command line. It is flexible, fast, and unobtrusive. The CLI tool and its documentation live at [taskwarrior.org](https://taskwarrior.org/download/).

This project brings that workflow to mobile and desktop: manage your tasks, filter them, and keep them in sync across all your devices.

<p align="center">
  <a href="https://taskwarrior.org/"><img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/65afcc8e-d5df-4b06-9ae5-093d51e20178" alt="Taskwarrior" width="160"></a>
</p>

## Screenshots

<p align="center">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/14f855c6-159a-4b44-95bd-68ca4be82ff6" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/4ecd6fe6-fded-4505-897f-b48e38813df3" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/ce628460-1ea8-4052-8344-b8df2dc06c8d" width="160">
  <img src="https://github.com/CCExtractor/taskwarrior-flutter/assets/47685150/041c3c41-6a50-433a-b628-661fb26156be" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/7cd0d242-491a-43b0-90ad-ae24ebcfb032" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/269ce68b-0e5c-4dec-8fe9-d53d81533270" width="160">
  <img src="https://github.com/CCExtractor/taskwarrior-flutter/assets/47685150/01377cac-56d1-4c1d-b0f4-372a3dc72f8d" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/8d802beb-dc3c-493d-8929-affbc10a7e67" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/51e64747-5ba2-4f9b-baed-f287a0ad58c4" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/d8f75a98-e3a0-4de9-892e-a1489f808201" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/8d1d83e9-e32d-447a-8c1d-33c4e76e0b0d" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/c1a134e9-b1f1-4b53-b7ac-7b87490d32be" width="160">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/e6f76f60-ae7e-42f7-a669-4e3f12201e13" width="160">
  <img src="https://github.com/prince02765/taskwarrior-flutter/assets/69643676/1011e85d-abd0-4821-8e88-a689b4487305" width="160">
</p>

## Built With

- [Dart](https://dart.dev/)
- [Flutter](https://flutter.dev/)
- [Rust](https://www.rust-lang.org/) — TaskChampion storage/sync via [`flutter_rust_bridge`](https://cjycode.com/flutter_rust_bridge/)
- [GetX](https://pub.dev/packages/get) — state management and routing

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/) — this repo pins the SDK with [FVM](https://fvm.app/) in `.fvmrc`.
- Android Studio (Android) and/or Xcode (iOS/macOS).
- Optional: a Rust toolchain with [`cargo-ndk`](https://github.com/bbqsrc/cargo-ndk) if you want to rebuild the native `libtc_helper.so` yourself. Android builds fall back to the committed libraries under `android/app/src/main/jniLibs/`.

### Run the app

```bash
# Clone
git clone https://github.com/CCExtractor/taskwarrior-flutter.git
cd taskwarrior-flutter

# Install the pinned SDK and dependencies (FVM)
fvm install
fvm flutter pub get

# Check your setup
fvm flutter doctor

# Run (production or nightly flavor)
fvm flutter run --flavor production
fvm flutter run --flavor nightly
```

If you are not using FVM, run the same commands with `flutter` and make sure your SDK matches the version in `.fvmrc`.

## Syncing

The app supports two sync backends. TaskChampion is the modern one and is recommended for new setups.

### TaskChampion (recommended)

The app syncs through TaskChampion. You can use [WingTask](https://app.wingtask.com/) as a hosted TaskChampion sync server to keep your tasks in sync across devices. Point the app at your server URL, client ID, and encryption secret.

### Legacy TaskServer

TaskServer lets you share tasks across clients and devices, and keeps an automatic backup of your data.

**Self-hosted TaskServer**

- Official setup guide: [taskserver-setup](https://gothenburgbitfactory.github.io/taskserver-setup/)
- Video tutorial: [Watch on YouTube](https://www.youtube.com/watch?v=6Ci_JyvVIaI&ab_channel=MetaphysicsComputing)
- Cloud hosting: run it on Azure or any other cloud provider for access from anywhere.
- Docker: [ogarcia/docker-taskd](https://github.com/ogarcia/docker-taskd)

## Contributing

Contributions of every kind are welcome — features, fixes, refactors, performance work, and documentation. See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide, and the [Contribution Guidelines & Development Practices](https://github.com/CCExtractor/taskwarrior-flutter/wiki/Contribution-Guidelines-&-Development-Practices) wiki page.

Found a bug? Open an [issue](https://github.com/CCExtractor/taskwarrior-flutter/issues/new).

Please prefix commits and pull requests with a type:

```
feat: a new feature
fix:  a bug fix
test: everything related to testing
docs: everything related to documentation
```

## Community

Join the `gsoc-taskwarrior` channel of the CCExtractor community on Slack:

[![Slack](https://img.shields.io/badge/chat-on_slack-purple.svg?style=for-the-badge&logo=slack)](https://ccextractor.org/public/general/support/)

## Project Timeline

This project started as a Google Summer of Code project. See the [GSoC project page](https://summerofcode.withgoogle.com/programs/2022/projects/8pYfxjXv).

For help getting started with Flutter, see the [online documentation](https://flutter.dev/docs).

## License

Distributed under the GNU General Public License v3.0. See [`LICENSE`](LICENSE) for the full text.

## Contact

- [Nishant Singhal](https://www.linkedin.com/in/nishant-singhal19/)
- [Mabud Alam](https://www.linkedin.com/in/mabud/)

Project link: [CCExtractor/taskwarrior-flutter](https://github.com/CCExtractor/taskwarrior-flutter)
