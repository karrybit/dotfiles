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


def original(repo, rel):
    return git(repo, "show", f"HEAD:{rel}")


def md_files(repo):
    return sorted(p for p in repo.rglob("*.md") if ".git" not in p.parts)


def all_docs(repo):
    return "\n".join(p.read_text() for p in md_files(repo))


def broken_links(repo):
    bad = []
    for p in md_files(repo):
        for target in re.findall(r"\]\(([^)\s]+)\)", p.read_text()):
            if re.match(r"[a-z]+:", target) or target.startswith("#"):
                continue
            path = target.split("#")[0]
            if path and not (p.parent / path).exists():
                bad.append(f"{p.relative_to(repo)} -> {target}")
    return bad


def has_all(text, needles):
    missing = [n for n in needles if n.lower() not in text.lower()]
    return not missing, missing


def check(name, aid, repo):
    ch = changes(repo)
    new_md = [f for f, s in ch.items() if s == "??" and f.endswith(".md")]
    readme = read(repo, "README.md")
    docs = all_docs(repo)

    if name == "bloated-readme":
        if aid == "flags-kept":
            return has_all(readme, ["--schema", "--delimiter", "--strict", "--max-errors", "--format"])
        if aid == "exit-codes-kept":
            ok = all(re.search(rf"(^|\|)\s*`?{c}`?\s*\|", readme, re.M) for c in "012")
            return ok, "table rows for 0/1/2" if not ok else ""
        if aid == "history-removed":
            return "1972" not in readme and "Fortran" not in readme, ""
        if aid == "best-practices-removed":
            return "journey, not a destination" not in readme and "Communicate with data producers" not in readme, ""
        if aid == "no-new-files":
            return list(ch) == ["README.md"] or not ch, ch
    if name == "over-split-docs":
        if aid == "pages-consolidated":
            gs = list((repo / "docs/getting-started").glob("*.md")) if (repo / "docs/getting-started").is_dir() else []
            return len(gs) <= 2, [p.name for p in gs]
        if aid == "commands-kept":
            return has_all(docs, ["docker pull ghcr.io/example/relayd:1.8", "docker run", "curl -X POST"])
        if aid == "caveats-kept":
            return has_all(docs, ["host.docker.internal", "status=502"])
        if aid == "links-resolve":
            bad = broken_links(repo)
            return not bad, bad
    if name == "mixed-responsibility":
        if aid == "user-info-in-readme":
            return has_all(readme, ["brew install", "--dry-run", "--checksum", "--delete", "取り消せない"])
        if aid == "release-moved-out":
            others = "\n".join(p.read_text() for p in md_files(repo) if p.name != "README.md")
            ok = "goreleaser" not in readme and "git tag" not in readme and "goreleaser" in others
            return ok, ""
        if aid == "invariant-kept":
            return "辞書順" in docs, ""
        if aid == "tap-token-hint-kept":
            return "HOMEBREW_TAP_TOKEN" in docs, ""
        if aid == "readme-links-moved":
            targets = [f for f, s in ch.items() if s == "??" and f.endswith(".md")]
            linked = all(Path(t).name in readme for t in targets)
            bad = broken_links(repo)
            return bool(targets) and linked and not bad, {"new": targets, "broken": bad}
    if name == "splittable-but-cohesive":
        if aid == "not-split":
            cfg = read(repo, "docs/configuration.md")
            sections = ["## listen", "## upstreams", "## oidc", "## session", "## policy", "## logging"]
            ok, missing = has_all(cfg, sections)
            return ok and not new_md, {"new": new_md, "missing": missing}
    if name == "good-docs-audit":
        if aid == "no-edits":
            return not ch, ch
    if name == "architecture-compress":
        before, after = len(original(repo, "ARCHITECTURE.md")), len(read(repo, "ARCHITECTURE.md"))
        if aid == "shorter":
            return after <= 0.7 * before, f"{after}/{before} = {after / before:.2f}"
        if aid == "rejected-alternatives-kept":
            a = read(repo, "ARCHITECTURE.md")
            return "PostgreSQL" in a and ("bbolt" in a or "BoltDB" in a), ""
        if aid == "single-process-constraint-kept":
            return has_all(read(repo, "ARCHITECTURE.md"), ["replicas: 1", "Recreate"])
        if aid == "backup-guidance-kept":
            return has_all(read(repo, "ARCHITECTURE.md"), ["Litestream", ".backup"])
    if name == "local-paragraph-edit":
        if aid == "diff-bounded":
            orig = original(repo, "README.md").splitlines()
            start = orig.index("## Authentication")
            end = next(i for i in range(start + 1, len(orig)) if orig[i].startswith("## "))
            diff = git(repo, "diff", "-U0", "--", "README.md")
            hunks = [tuple(int(x or 1) for x in m) for m in re.findall(r"^@@ -(\d+)(?:,(\d+))?", diff, re.M)]
            outside = [h for h in hunks if not (start + 1 <= h[0] <= end)]
            return set(ch) <= {"README.md"} and not outside, {"files": ch, "outside_hunks": outside}
        if aid == "duplicate-pagination-untouched":
            return readme.count("## Pagination") == 2, ""
        if aid == "facts-kept":
            auth = readme.split("## Authentication")[1].split("\n## ")[0]
            ok1 = re.search(r"one hour|1 hour|60 minutes", auth, re.I)
            ok2 = re.search(r"60 seconds|sixty seconds|60 s\b|60-second", auth, re.I)
            ok, missing = has_all(auth, ["auto_refresh=False", "client.refresh()", "AuthError"])
            return bool(ok1 and ok2 and ok), {"hour": bool(ok1), "60s": bool(ok2), "missing": missing}
    if name == "audience-change":
        if aid == "commands-kept":
            q = "\n".join(p.read_text() for p in md_files(repo))
            cmds = ["kubectl config use-context staging", "get secret inventory-db", "apply -f deploy/app.yaml",
                    "rollout status deploy/inventory-api", "port-forward deploy/inventory-api 8080:8080",
                    "curl localhost:8080/healthz", "describe pod -l app=inventory-api", "rollout undo deploy/inventory-api"]
            return has_all(q, cmds)
    if name == "code-change-stale-docs":
        ops = read(repo, "docs/operations.md")
        if aid == "env-var-updated":
            # The CI secret's own name may legitimately stay; only the env var name changed.
            ok = all("SHIPIT_DB_URL" not in t.replace("secrets.SHIPIT_DB_URL", "") and "DATABASE_URL" in t
                     for t in (readme, ops))
            return ok, ""
        if aid == "legacy-mode-removed":
            offenders = [str(p.relative_to(repo)) for p in md_files(repo)
                         if "--legacy-mode" in p.read_text() and "adr" not in p.parts]
            return not offenders, offenders
        if aid == "region-default-removed":
            return not any(re.search(r"default[^\n]{0,20}us-east-1", t) for t in (readme, ops)), ""
        if aid == "faq-untouched":
            return "docs/faq.md" not in ch, ""
        if aid == "adr-history-preserved":
            adr = read(repo, "docs/adr/0003-database-url-env.md")
            return "Read it from the `SHIPIT_DB_URL` environment variable" in adr, ""
        if aid == "no-new-files":
            extra = [f for f, s in ch.items() if s == "??" and not f.startswith("docs/adr/")]
            return not extra, extra
    if name == "missing-info":
        if aid == "redis-url-added":
            return "REDIS_URL" in readme, ""
        if aid == "migrate-before-run":
            i, j = readme.find("make migrate"), readme.find("make run")
            return 0 <= i < j, f"migrate@{i} run@{j}"
        if aid == "services-started":
            return bool(re.search(r"docker[ -]compose up|compose up", readme)), ""
    if name == "useful-repetition":
        rb = read(repo, "docs/runbook-failover.md")
        if aid == "intro-or-summary-removed":
            return "## About this runbook" not in rb or "## Summary" not in rb, ""
        if aid == "auto-recovery-reason-kept":
            return "auto-recovery" in rb, ""
        if aid == "commands-kept":
            return has_all(rb, ["pg_ctl promote", "set-db-host.sh", "restart-apps.sh", "healthz/write", "rebuild-replica.sh"])
    if name == "new-project-docs":
        if aid == "minimal-set":
            return len(new_md) <= 2, new_md
        if aid == "flags-documented":
            return has_all(docs, ["-dir", "-pattern", "-max-age", "-compress", "-dry-run"])
    if name == "add-feature-docs":
        cfg = read(repo, "docs/configuration.md")
        if aid == "stale-claim-removed":
            return "does not authenticate" not in readme, ""
        if aid == "config-keys-documented":
            return has_all(cfg, ["secret_env", "previous_secret_env", "X-Hub-Signature-256"])
        if aid == "failure-behavior-documented":
            return "401" in docs, ""
        if aid == "existing-docs-preferred":
            return not new_md, new_md
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
