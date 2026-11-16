#!/bin/bash
set -eu
fixtures="$(dirname "$0")/../../fixtures"
cp -R "$fixtures/export-api/." .
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm base
git tag base
cp -R "$fixtures/export-api-v2/." .
git add -A
git -c user.name=implementer -c user.email=implementer@example.invalid commit -qm "Add get_export"
