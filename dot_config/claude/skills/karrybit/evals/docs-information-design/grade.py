#!/usr/bin/env python3
"""Grade the script-type assertions in evals.json for one iteration directory.

Layout expected under ITERATION_DIR:
  eval-<fixture-name>/<config>/repo/      fixture copy committed as "fixture", then edited
  eval-<fixture-name>/<config>/outputs/   response.md written by the run

Writes grading.json next to each repo (judge-type assertions are left for a
human or model grader and recorded as passed=null) and prints a summary table.
"""

import json
import re
import subprocess
import sys
from pathlib import Path

EVALS = json.loads((Path(__file__).parent / "evals.json").read_text())


def git(repo, *args):
    return subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True).stdout


def changes(repo):
    """Return {path: status} for working-tree changes against the fixture commit."""
    out = {}
    for line in git(repo, "status", "--porcelain", "--untracked-files=all").splitlines():
        status, path = line[:2].strip(), line[3:]
        if "__pycache__" in path:
            continue
        if " -> " in path:
            old, path = path.split(" -> ")
            out[old] = "D"
        out[path] = status
    return out


def read(repo, rel):
    p = repo / rel
    return p.read_text() if p.is_file() else ""


def md_files(repo):
    return sorted(p for p in repo.rglob("*.md") if ".git" not in p.parts)


def all_docs(repo):
    return "\n".join(p.read_text() for p in md_files(repo))


def has_all(text, needles):
    missing = [n for n in needles if n.lower() not in text.lower()]
    return not missing, missing


def check(name, aid, repo):
    if name == "good-docs-audit":
        if aid == "no-edits":
            ch = changes(repo)
            return not ch, ch
    if name == "code-change-stale-docs":
        readme, ops = read(repo, "README.md"), read(repo, "docs/operations.md")
        if aid == "env-var-updated":
            # Look for the fixture's stale instructions, so a migration note naming the old variable passes.
            stale = r"export SHIPIT_DB_URL|as `SHIPIT_DB_URL`|^\s*SHIPIT_DB_URL\s*:|KeyError: .SHIPIT_DB_URL"
            ok = all(not re.search(stale, t, re.M) and "DATABASE_URL" in t for t in (readme, ops))
            return ok, ""
        if aid == "legacy-mode-removed":
            offers = r"^(?!.*(?:removed|no longer|deprecated|dropped|削除|廃止)).*--legacy-mode"
            offenders = [str(p.relative_to(repo)) for p in md_files(repo)
                         if re.search(offers, p.read_text(), re.M) and "adr" not in p.parts]
            return not offenders, offenders
    if name == "new-project-docs":
        if aid == "flags-documented":
            return has_all(all_docs(repo), ["-dir", "-pattern", "-max-age", "-compress", "-dry-run"])
    return None, "no script check"


def main(iteration):
    iteration = Path(iteration)
    rows = []
    for ev in EVALS["evals"]:
        fixture = Path(ev["files"][0]).name
        for run in sorted((iteration / f"eval-{fixture}").glob("*/repo")):
            config = run.parent.name
            results = []
            for a in ev["assertions"]:
                if a["type"] == "judge":
                    results.append({"text": a["text"], "passed": None, "evidence": "judge"})
                    continue
                passed, evidence = check(ev["name"], a["id"], run)
                results.append({"text": a["text"], "passed": bool(passed), "evidence": str(evidence)})
            scripted = [r for r in results if r["passed"] is not None]
            summary = {"passed": sum(r["passed"] for r in scripted), "total": len(scripted)}
            (run.parent / "grading.json").write_text(json.dumps(
                {"expectations": results, "summary": summary}, ensure_ascii=False, indent=2))
            rows.append((ev["name"], config, summary["passed"], summary["total"],
                         [r["text"] for r in scripted if not r["passed"]]))
    for name, config, p, t, failed in rows:
        print(f"{name:26} {config:14} {p}/{t}  " + ("; ".join(failed) if failed else ""))


if __name__ == "__main__":
    main(sys.argv[1])
