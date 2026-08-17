---
title: "Architecture"
description: "How TaskWarrior Mobile is built — Flutter UI over a native Rust core."
weight: 3
---

TaskWarrior Mobile is a Flutter app sitting on top of a native Rust core, so the same
task engine that powers TaskWarrior on the desktop runs unchanged on your phone.

## Layers

- **UI — Flutter (Dart).** Screens, navigation, and state management use
  [GetX](https://pub.dev/packages/get). This layer never talks to the network for task
  data; it reads and writes through the core.
- **Core — Rust (`tc_helper`).** A thin wrapper around
  [TaskChampion](https://github.com/GothenburgBitFactory/taskchampion) exposed to Dart
  through [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge). It
  owns task storage, mutations, and sync.
- **Storage & sync — TaskChampion.** Tasks live in a local replica on the device.
  Syncing reconciles that replica with a TaskChampion sync server; there is no
  bespoke HTTP API in between.

## Offline-first data flow

```
tap "complete"  ─▶  Flutter  ─▶  Rust FFI  ─▶  local replica   (instant, no network)
                                                     │
                                            (later, when online)
                                                     ▼
                                          TaskChampion sync server
```

Every create, edit, and complete is committed to the local replica synchronously, so the
UI never waits on the network. Synchronisation is a separate, best-effort step that runs
when connectivity is available.

## Why a Rust core?

Reusing TaskChampion means the mobile app shares TaskWarrior's battle-tested task model —
recurrence, dependencies, annotations, tags, and the sync protocol — instead of
reimplementing them. The Rust bridge surfaces those capabilities to the Flutter UI with a
small, typed FFI surface.
