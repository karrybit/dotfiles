# shipit

shipit deploys service manifests and records each deployment in a Postgres database.

## Usage

```
export SHIPIT_DB_URL=postgres://shipit@db.internal/shipit
shipit --dry-run
shipit
```

`--region` selects the target region (default `us-east-1`).

Manifests in the v1 format are still supported with `--legacy-mode`.

See [docs/operations.md](docs/operations.md) for running shipit in CI.
