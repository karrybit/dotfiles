#!/bin/bash
set -eu
fixtures="$(dirname "$0")/../../fixtures"
cp -R "$fixtures/field-rename/." .
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm base
git tag base
cp -R "$fixtures/field-rename-v1/." .
git add -A
git -c user.name=implementer -c user.email=implementer@example.invalid commit -qm "Rename created_at to created_on"
