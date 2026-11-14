#!/bin/bash
set -eu
cp -R "$(dirname "$0")/../../fixtures/04-splittable-but-cohesive/." .
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
