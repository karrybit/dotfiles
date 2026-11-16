#!/bin/bash
set -eu
case_dir=$(dirname "$0")
cp -R "$case_dir/../../fixtures/audit-console/." .
mkdir -p docs/requirements
cp "$case_dir/requirements.md" docs/requirements/audit-log-export.md
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
