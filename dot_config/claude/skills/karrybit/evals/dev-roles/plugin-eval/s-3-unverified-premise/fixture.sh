#!/bin/bash
set -eu
fixtures="$(dirname "$0")/../../fixtures"
cp -R "$fixtures/audit-console/." .
cp -R "$fixtures/audit-console-limits/." .
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
