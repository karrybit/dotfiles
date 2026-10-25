# Operations runbook

## Reloading configuration

Send `SIGHUP` to the gatekeeper process. Invalid configuration is rejected and the previous configuration stays active; check the log for `config rejected`.

## Rotating the session secret

See `session.secret` and `session.previous_secrets` in the [configuration reference](configuration.md#session).
