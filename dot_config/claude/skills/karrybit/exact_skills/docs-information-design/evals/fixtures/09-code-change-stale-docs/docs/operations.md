# Running shipit in CI

Store the database URL as a CI secret and expose it as `SHIPIT_DB_URL`.

```yaml
- run: shipit --region ap-northeast-1
  env:
    SHIPIT_DB_URL: ${{ secrets.SHIPIT_DB_URL }}
```

Run `shipit --dry-run` on pull requests and the real deployment only on `main`.

## Troubleshooting

- `KeyError: 'SHIPIT_DB_URL'`: the secret is not exposed to the job.
- Deployment lands in the wrong region: you relied on the default `us-east-1`; pass `--region` explicitly.
