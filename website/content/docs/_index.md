---
title: "Documentation"
description: "Developer and user documentation for TaskWarrior Mobile."
---

Documentation for TaskWarrior Mobile. This section is a living skeleton that grows
alongside the app.

## Architecture at a glance

- **UI** — Flutter (Dart) with GetX for state management and routing.
- **Core** — a Rust FFI bridge (`tc_helper`, via `flutter_rust_bridge`) that wraps
  [TaskChampion](https://github.com/GothenburgBitFactory/taskchampion) for task storage.
- **Sync** — offline-first: changes hit a local SQLite/TaskChampion replica immediately
  and synchronise with a TaskChampion sync server when connectivity is available.

## Getting the app

See the [downloads page](../downloads/) for stable releases and nightly builds.

## Contributing

Contributions are welcome. Start with the
[CONTRIBUTING guide](https://github.com/CCExtractor/taskwarrior-flutter/blob/main/CONTRIBUTING.md)
in the repository, and join the [CCExtractor community](https://ccextractor.org/) on Slack
or Zulip.
