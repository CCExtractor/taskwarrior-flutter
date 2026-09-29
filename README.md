<p align="center">
  <img src="https://github.com/Pavel401/taskwarrior-flutter/assets/47685150/1ffb623b-b147-4176-9f7c-abda544b257c" alt="Taskwarrior Mobile App" width="720">
</p>

<h1 align="center">Taskwarrior Mobile App</h1>

<p align="center">
  A cross-platform Flutter client for <a href="https://taskwarrior.org/">Taskwarrior</a>.
</p>

<p align="center">
  <a href="https://ccextractor.org/public/general/support/"><img src="https://img.shields.io/badge/chat-on%20Zulip-blue.svg?style=for-the-badge" alt="Zulip"></a>
  <a href="https://play.google.com/store/apps/details?id=com.ccextractor.taskwarriorflutter&hl=en_IN"><img src="https://img.shields.io/badge/Google%20Play-Download-green.svg?style=for-the-badge&logo=google-play&logoColor=white" alt="Get it on Google Play"></a>
  <img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge" alt="License: GPL v3">
  <img src="https://img.shields.io/badge/Flutter-3.44.9-02569B.svg?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/GSoC-2022-orange.svg?style=for-the-badge" alt="Google Summer of Code 2022">
</p>

---

## Table of Contents

- [About](#about)
- [Screenshots](#screenshots)
- [Built With](#built-with)
- [Setup](#setup)
- [Syncing](#syncing)
  - [TaskChampion (recommended)](#taskchampion-recommended)
  - [Legacy TaskServer](#legacy-taskserver)
- [Contributing](#contributing)
- [Google Summer of Code](#google-summer-of-code)
- [Community](#community)
- [Contributors](#contributors)
- [Maintainers](#maintainers)
- [License](#license)

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
- [Rust](https://www.rust-lang.org/): TaskChampion storage/sync via [`flutter_rust_bridge`](https://cjycode.com/flutter_rust_bridge/)
- [GetX](https://pub.dev/packages/get): state management and routing

## Setup

Full local setup instructions (FVM, the pinned Flutter SDK, Android/iOS,
optional Rust, and which files not to touch) live in **[SETUP.md](SETUP.md)**.

Quick start:

```bash
# Clone
git clone https://github.com/CCExtractor/taskwarrior-flutter.git
cd taskwarrior-flutter

# Install the pinned SDK and dependencies (FVM)
fvm install
fvm flutter pub get

# Check your setup
fvm flutter doctor

# Run (the Android flavor is required)
fvm flutter run --flavor production
```

If you are not using FVM, run the same commands with `flutter` and make sure
your SDK matches the version in `.fvmrc`. See [SETUP.md](SETUP.md) for details.

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

Contributions of every kind are welcome: features, fixes, refactors, performance work, and documentation.

- Read **[CONTRIBUTING.md](CONTRIBUTING.md)** for the full workflow, including how to raise an issue and open a pull request.
- Read **[SETUP.md](SETUP.md)** to get the project running locally.
- Maintainers are listed in **[AUTHORS.md](AUTHORS.md)**.
- Found a bug? Open an [issue](https://github.com/CCExtractor/taskwarrior-flutter/issues/new).

We follow an **issue-first** policy: please open an issue and wait for a maintainer to validate and assign it before starting work on a pull request.

## Google Summer of Code

This project is supported by [Google Summer of Code](https://summerofcode.withgoogle.com/). It started in 2022 as a [GSoC 2022 project](https://summerofcode.withgoogle.com/programs/2022/projects/8pYfxjXv) under the [CCExtractor Development](https://ccextractor.org/) umbrella organization, and has taken part in several GSoC editions since. Other than this generous sponsorship, the project has no relationship with Google.

We welcome future GSoC contributors. See the [CCExtractor GSoC ideas page](https://ccextractor.org/public/gsoc/) for current project ideas and application guidance.

## Community

Join the CCExtractor community on Zulip for questions, discussions, and contributions:

[![Zulip](https://img.shields.io/badge/chat-on%20Zulip-blue.svg?style=for-the-badge)](https://ccextractor.org/public/general/support/)

## Contributors

<a href="https://github.com/CCExtractor/taskwarrior-flutter/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=CCExtractor/taskwarrior-flutter" alt="Contributors" />
</a>

## Maintainers

- [Shubham Ingale](https://github.com/SGI-CAPP-AT2) ([@SGI-CAPP-AT2](https://github.com/SGI-CAPP-AT2))
- [Chinmay Chaudhari](https://github.com/BrawlerXull) ([@BrawlerXull](https://github.com/BrawlerXull))
- [Carlos Fernandez Sanz](https://github.com/cfsmp3) ([@cfsmp3](https://github.com/cfsmp3))
- [Mabud Alam](https://github.com/MabudAlam401) ([@MabudAlam401](https://github.com/MabudAlam401))

## License

Distributed under the GNU General Public License v3.0. See [`LICENSE`](LICENSE) for the full text.
