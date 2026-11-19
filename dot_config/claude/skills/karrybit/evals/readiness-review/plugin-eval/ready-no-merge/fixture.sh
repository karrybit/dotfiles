#!/bin/bash
set -eu
here="$(dirname "$0")"
cp -R "$here/../../fixtures/wtctl/." .
cp "$here/docs/plan.md" "$here/docs/CONTRIBUTING.md" docs/
chmod +x bin/wt-new bin/wt-close bin/wt-list tests/run
printf 'state/\n.worktrees/\ntests/work/\n' > .gitignore
git init -q -b main
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
git switch -q -c drop-branch-column
cp -R "$here/../../fixtures/wtctl-v1/." .
chmod +x bin/wt-new bin/wt-list tests/run
git add -A
git -c user.name=implementer -c user.email=implementer@example.invalid commit -qm "Read the current branch in wt-list and write two ledger columns"
cp "$here/docs/verification.md" docs/
git add -A
git -c user.name=verifier -c user.email=verifier@example.invalid commit -qm "Add the verification report"
