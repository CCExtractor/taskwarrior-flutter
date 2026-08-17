#!/usr/bin/env python3
"""Record a nightly build in the website's build-log data file.

Prepends an entry describing the current commit to
``website/data/nightly_builds.json`` (newest first) and keeps only the most
recent ``MAX_ENTRIES``. The Hugo ``nightly-builds`` shortcode renders this file.

Run from the repository root (as the CI workflow does):

    python3 update_build_log.py <status> <artifact_url> <build_number> [sha] [msg]

All arguments are optional:
    status        "success" (default) or "failure"
    artifact_url  link to the built APK ("" if none)
    build_number  CI run number ("" if unknown)
    sha           commit being deployed; read from git HEAD if omitted
    msg           its subject line; read from git HEAD if omitted

`sha` and `msg` are passed explicitly by CI because the deploy switches the work
tree to the branch that hosts the site before this runs — at that point git HEAD
is that branch's own commit, not the app commit being released, so reading git
would record the wrong thing. Omitting them (running by hand) falls back to git.
"""

import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

LOG = Path("website/data/nightly_builds.json")
MAX_ENTRIES = 90


def _git(*args: str) -> str:
    return subprocess.check_output(["git", *args]).decode().strip()


def main(
    status: str = "success",
    artifact: str = "",
    build_number: str = "",
    sha: str = "",
    msg: str = "",
) -> None:
    entry = {
        "ts": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "sha": (sha or _git("rev-parse", "HEAD"))[:8],
        # Only the subject line; a passed-in message may carry a full body.
        "msg": (msg or _git("log", "-1", "--pretty=%s")).strip().splitlines()[0]
        if (msg or True)
        else "",
        "status": status,
        "artifact": artifact,
        "build": build_number,
    }

    entries = []
    if LOG.exists():
        try:
            entries = json.loads(LOG.read_text() or "[]")
        except json.JSONDecodeError:
            entries = []

    entries.insert(0, entry)
    entries = entries[:MAX_ENTRIES]

    LOG.parent.mkdir(parents=True, exist_ok=True)
    LOG.write_text(json.dumps(entries, indent=2) + "\n")
    print(
        f"Recorded nightly build {entry['sha']} ({status}); "
        f"{len(entries)} entr{'y' if len(entries) == 1 else 'ies'} in {LOG}."
    )


if __name__ == "__main__":
    main(*sys.argv[1:])
