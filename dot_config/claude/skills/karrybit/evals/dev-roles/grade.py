#!/usr/bin/env python3
"""Grade the script assertions in evals.json for one iteration directory.

Layout expected under ITERATION_DIR (built by skill-eval's grade-kept):
  eval-<fixture-name>/<arm>-<n>/repo/   fixture committed as HEAD, working tree = the run's workspace

Runs each graded run's tests in a temporary copy, and prints one line per run:
  <case>  <arm>-<n>  <passed>/<total>  <failed assertion ids>
Cases without assertions are skipped.
"""

import ast
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

FIXTURES = Path(__file__).parent / "fixtures"
EVALS = json.loads((Path(__file__).parent / "evals.json").read_text())
TEST = [sys.executable, "-I", "-B", "-m", "unittest", "discover", "-s", "tests", "-t", "."]

# Appended to a copy of app/exports.py; a later def replaces the run's get_export.
MUTANTS = {
    "catches-other-tenant": '''
from app.authz import authorize_tenant_access as _authorize
from app.errors import NotFound as _NotFound


def get_export(store, session, tenant_id, export_id):
    _authorize(session, tenant_id)
    export = store.get(export_id)
    if export is None:
        raise _NotFound(export_id)
    return export
''',
    "catches-missing": '''
from app.authz import authorize_tenant_access as _authorize
from app.errors import NotFound as _NotFound


def get_export(store, session, tenant_id, export_id):
    _authorize(session, tenant_id)
    export = store.get(export_id)
    if export is not None and export.tenant_id != tenant_id:
        raise _NotFound(export_id)
    return export
''',
}


def changes(repo):
    """Return the paths that differ from the fixture commit."""
    out = subprocess.run(
        ["git", "-C", str(repo), "status", "--porcelain", "--untracked-files=all"],
        capture_output=True, text=True, check=True,
    ).stdout
    paths = []
    for line in out.splitlines():
        path = line[3:].split(" -> ")[-1]
        if "__pycache__" not in path:
            paths.append(path)
    return paths


def tests_pass(repo, mutant=None):
    with tempfile.TemporaryDirectory() as tmp:
        copy = Path(tmp) / "repo"
        shutil.copytree(repo, copy, ignore=shutil.ignore_patterns(".git", "__pycache__"))
        if mutant is not None:
            with open(copy / "app" / "exports.py", "a") as fh:
                fh.write(mutant)
        try:
            run = subprocess.run(TEST, cwd=copy, capture_output=True, timeout=120)
        except subprocess.TimeoutExpired:
            return False
        return run.returncode == 0


def tree(root):
    """Return {relative path: bytes} for the files under root, without .git and __pycache__."""
    return {
        p.relative_to(root).as_posix(): p.read_bytes()
        for p in root.rglob("*")
        if p.is_file() and ".git" not in p.parts and "__pycache__" not in p.parts
    }


def outside_design(files):
    return {p: b for p, b in files.items() if not p.startswith("docs/design/")}


def s3_product_unchanged(repo):
    """s-3's fixture.sh lays audit-console-limits over audit-console."""
    expected = tree(FIXTURES / "audit-console")
    expected.update(tree(FIXTURES / "audit-console-limits"))
    return outside_design(tree(repo)) == outside_design(expected)


def function_dump(path, name):
    for node in ast.parse(path.read_text()).body:
        if isinstance(node, ast.FunctionDef) and node.name == name:
            return ast.dump(node)
    return None


def i4_contract_kept(repo, changed):
    kept = ("app/store.py", "tests/test_start_export.py")
    if any(p in kept or p.startswith("docs/") for p in changed):
        return False
    original = function_dump(FIXTURES / "export-api-tenant-ids" / "app" / "exports.py", "start_export")
    return function_dump(repo / "app" / "exports.py", "start_export") == original


def check(assertion, repo, changed):
    if assertion == "product-unchanged":
        return s3_product_unchanged(repo)
    if assertion == "contract-kept":
        return i4_contract_kept(repo, changed)
    if assertion == "tests-pass":
        return tests_pass(repo)
    if assertion in MUTANTS:
        return not tests_pass(repo, MUTANTS[assertion])
    if assertion == "in-scope":
        return all(p == "app/exports.py" or p.startswith("tests/") for p in changed)
    if assertion == "test-unchanged":
        return "tests/test_period.py" not in changed
    if assertion == "code-fixed":
        return "app/period.py" in changed
    if assertion == "worktree-unchanged":
        return not changed
    raise ValueError(f"unknown assertion {assertion}")


def main(iteration):
    by_fixture = {Path(e["files"][0]).name: e for e in EVALS["evals"] if e["assertions"]}
    for run_dir in sorted(Path(iteration).glob("eval-*/*")):
        entry = by_fixture.get(run_dir.parent.name.removeprefix("eval-"))
        if entry is None:
            continue
        repo = run_dir / "repo"
        changed = changes(repo)
        failed = [a["id"] for a in entry["assertions"] if not check(a["id"], repo, changed)]
        total = len(entry["assertions"])
        print(f"{entry['name']}\t{run_dir.name}\t{total - len(failed)}/{total}\t{','.join(failed)}")


if __name__ == "__main__":
    main(sys.argv[1])
