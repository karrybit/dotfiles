#!/bin/bash
set -eu
cp -R "$(dirname "$0")/../../fixtures/retry-lib/." .
cp -R "$(dirname "$0")/../../fixtures/retry-explained/." .
rm explain/retry.html
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
