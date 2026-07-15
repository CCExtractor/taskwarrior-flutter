---
title: "Features"
description: "What TaskWarrior Mobile can do — offline-first task management with native TaskChampion sync."
---

TaskWarrior Mobile brings the full TaskWarrior task model to your phone and desktop,
without giving up speed or working offline.

## Task management

- **Rich tasks** — descriptions, projects, tags, priorities, and due dates.
- **Recurring tasks** — repeat tasks on a schedule.
- **Dependencies** — mark tasks as blocking or blocked by others so you always know
  what is actionable.
- **Annotations** — attach timestamped notes to any task.
- **Fast capture and edit** — add or change a task in a couple of taps.

## Offline-first

- Every create, edit, and complete is written to a **local replica instantly** — no
  spinner, no waiting on the network.
- The app is fully usable with no connectivity at all; sync is optional.

## Native TaskChampion sync

- Syncs through a [TaskChampion](https://github.com/GothenburgBitFactory/taskchampion)
  sync server — the same protocol used by TaskWarrior 3.x on the desktop.
- **End-to-end encrypted**: your tasks are encrypted locally before upload, so the server
  only ever stores ciphertext.
- Credentials are **validated against the server before they are saved**, so a bad URL or
  secret is caught immediately.

## Cross-platform

- One Flutter codebase targeting **Android, iOS, Windows, macOS, and Linux**.
- A shared native Rust core keeps behaviour consistent everywhere.

## Open source

- Developed in the open on [GitHub](https://github.com/CCExtractor/taskwarrior-flutter)
  and maintained by [CCExtractor](https://ccextractor.org/).
- Automated [nightly builds](../downloads/#nightly-builds) let you try the latest changes.

Ready to try it? Head to the [downloads page](../downloads/).
