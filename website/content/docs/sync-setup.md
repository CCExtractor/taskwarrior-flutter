---
title: "Setting up sync"
description: "Connect TaskWarrior Mobile to a TaskChampion sync server."
weight: 2
---

TaskWarrior Mobile syncs through a [TaskChampion](https://github.com/GothenburgBitFactory/taskchampion)
sync server — the same protocol used by TaskWarrior 3.x on the desktop. Sync is
**optional and offline-first**: your tasks always live in a local replica, and syncing
simply reconciles that replica with the server when you are online.

## What you need

Three values from your TaskChampion sync server:

| Field | Description |
|---|---|
| **Sync server URL** | The base URL of the TaskChampion server, e.g. `https://example.org/taskchampion/`. |
| **Client ID** | A UUID identifying your replica on the server. |
| **Encryption secret** | The secret used to encrypt your data end-to-end. Only clients that share it can read your tasks. |

The server never sees your task data in the clear — everything is encrypted locally with
your encryption secret before it is uploaded.

## Connecting

1. Open **Profile** → change the sync server → choose **Taskchampion**.
2. Tap **Configure** and paste the three values above.
3. Tap **Save**. The app performs a live sync against the server to confirm the
   credentials work *before* it stores them — if anything is wrong, you find out
   immediately instead of silently failing later.

Once connected, changes flow both ways whenever you have connectivity. You can keep
working offline at any time; the next sync catches the server up.

## Self-hosting a server

Any TaskChampion-compatible sync server works. See the upstream
[TaskChampion sync-server](https://github.com/GothenburgBitFactory/taskchampion-sync-server)
project to run your own.
