#!/bin/bash
set -eu
here="$(dirname "$0")"
cp -R "$here/../../fixtures/wtctl/." .
cp -R "$here/docs/." docs/
chmod +x bin/wt-new bin/wt-close bin/wt-list tests/run
printf 'state/\n.worktrees/\ntests/work/\n' > .gitignore
git init -q -b main
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
