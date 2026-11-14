#!/bin/bash
set -eu
cp -R "$(dirname "$0")/../../fixtures/12-new-project-docs/." .
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
