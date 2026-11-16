#!/bin/bash
set -eu
case_dir=$(dirname "$0")
cp -R "$case_dir/../../fixtures/audit-console/." .
mkdir -p docs/notes
cp "$case_dir/meeting-note.md" docs/notes/2026-10-20-audit-log-export.md
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
