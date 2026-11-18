#!/usr/bin/env python3
"""Grade the script assertions in evals.json for one iteration directory.

Layout expected under ITERATION_DIR (built by skill-eval's grade-kept):
  eval-<fixture-name>/<arm>-<n>/repo/   fixture committed as HEAD, working tree = the run's workspace

Assertions per run:
  note-only      the case's note is the only path that differs from the fixture
  check-passes   the fixture's check script, not the workspace's copy, exits 0 on the note (cases with "check")

Prints one line per run:
  <case>  <arm>-<n>  <passed>/<total>  <failed assertion ids>
"""

import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).parent
EVALS = json.loads((HERE / "evals.json").read_text())["evals"]


def changes(repo):
    """Return the paths that differ from the fixture commit."""
    out = subprocess.run(
        ["git", "-C", str(repo), "status", "--porcelain", "--untracked-files=all"],
        capture_output=True, text=True, check=True,
    ).stdout
    return [line[3:] for line in out.splitlines()]


def main(iteration):
    for case in EVALS:
        fixture = Path(case["files"][0]).name
        for repo in sorted((iteration / f"eval-{fixture}").glob("*/repo")):
            failed = []
            if changes(repo) != [case["note"]]:
                failed.append("note-only")
            total = 1
            if "check" in case:
                total += 1
                check = ["sh", str(HERE / case["check"]), str(repo / case["note"])]
                if subprocess.run(check, capture_output=True).returncode != 0:
                    failed.append("check-passes")
            print(f"{case['name']}\t{repo.parent.name}\t{total - len(failed)}/{total}\t{' '.join(failed)}")


if __name__ == "__main__":
    main(Path(sys.argv[1]))
