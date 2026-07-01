#!/usr/bin/env python3
"""Record a nightly build in the website's build-log data file.

Prepends an entry describing the current commit to
``website/data/nightly_builds.json`` (newest first) and keeps only the most
recent ``MAX_ENTRIES``. The Hugo ``nightly-builds`` shortcode renders this file.

Run from the repository root (as the CI workflow does):

    python3 scripts/update_build_log.py <status> <artifact_url> <build_number>

All arguments are optional:
    status        "success" (default) or "failure"
    artifact_url  link to the built APK ("" if none)
    build_number  CI run number ("" if unknown)
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


def main(status: str = "success", artifact: str = "", build_number: str = "") -> None:
    entry = {
        "ts": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "sha": _git("rev-parse", "HEAD")[:8],
        "msg": _git("log", "-1", "--pretty=%s"),
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
