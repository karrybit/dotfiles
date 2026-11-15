#!/bin/bash
set -eu
cp -R "$(dirname "$0")/../../fixtures/jobq/." .
cp -R "$(dirname "$0")/../../fixtures/jobq-frontmatter/." .
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
