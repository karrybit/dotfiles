#!/bin/bash
set -eu
case_dir=$(dirname "$0")
cp -R "$case_dir/../../fixtures/export-api/." .
mkdir -p docs/api
cp "$case_dir/exports-api.md" docs/api/exports.md
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
