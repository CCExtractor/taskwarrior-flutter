---
title: "FAQ"
description: "Frequently asked questions about TaskWarrior Mobile."
weight: 4
---

## Do I need a sync server to use the app?

No. TaskWarrior Mobile is fully usable offline — tasks are stored in a local replica on
your device. A sync server is only needed if you want your tasks mirrored to another
device or backed up remotely.

## Is my data encrypted?

Yes. When you sync, your tasks are encrypted locally with your encryption secret before
being uploaded. The server stores only ciphertext; only clients that hold the secret can
read your tasks.

## Which platforms are supported?

The app targets Android, iOS, Windows, macOS, and Linux from a single Flutter codebase.
Android builds are published as APKs on the [downloads page](../../downloads/).

## Does it work with my existing TaskWarrior setup?

If your TaskWarrior 3.x desktop syncs through a TaskChampion sync server, point the app at
the same server, client ID, and encryption secret and your tasks will sync between them.
See [setting up sync](../sync-setup/).

## What's the difference between stable and nightly builds?

Stable builds are tagged releases meant for everyday use. Nightly builds are automatic
snapshots of the `main` branch — useful for trying the latest changes, but less tested.

## Where do I report a bug or request a feature?

Open an issue on the
[GitHub repository](https://github.com/CCExtractor/taskwarrior-flutter/issues). Pull
requests are welcome too — see the [contributing notes](../../docs/#contributing).
