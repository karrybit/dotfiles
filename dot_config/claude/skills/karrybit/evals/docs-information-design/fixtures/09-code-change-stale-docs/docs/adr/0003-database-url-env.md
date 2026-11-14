# 3. Read the database URL from SHIPIT_DB_URL

Status: accepted (2024-11-08)

## Context

shipit needs a Postgres connection string in CI and on laptops.

## Decision

Read it from the `SHIPIT_DB_URL` environment variable, prefixed to avoid clashing with application variables in the same CI job.

## Consequences

CI jobs must map their secret to `SHIPIT_DB_URL`.
