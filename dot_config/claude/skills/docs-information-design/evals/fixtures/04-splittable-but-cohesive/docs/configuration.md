# Configuration reference

gatekeeper reads a single YAML file (default `/etc/gatekeeper.yaml`, override with `--config`). Every key below is optional unless marked **required**. Unknown keys are rejected at startup so typos fail loudly.

Contents: [listen](#listen) · [upstreams](#upstreams) · [oidc](#oidc) · [session](#session) · [policy](#policy) · [logging](#logging) · [Complete example](#complete-example)

## listen

| Key | Default | Meaning |
| --- | --- | --- |
| `listen.address` | `:8443` | Address to bind |
| `listen.tls.cert_file` | **required** | PEM certificate chain |
| `listen.tls.key_file` | **required** | PEM private key |
| `listen.tls.min_version` | `1.2` | Minimum TLS version (`1.2` or `1.3`) |
| `listen.read_timeout` | `30s` | Per-request read timeout |

gatekeeper refuses to start without TLS; there is no plaintext mode, because session cookies are marked `Secure`.

## upstreams

A list of internal services. Requests are matched by `host`, then by the longest `path_prefix`.

| Key | Default | Meaning |
| --- | --- | --- |
| `upstreams[].name` | **required** | Identifier used in `policy` rules and logs |
| `upstreams[].host` | **required** | Public host name to match |
| `upstreams[].path_prefix` | `/` | Path prefix to match |
| `upstreams[].target` | **required** | Upstream URL |
| `upstreams[].timeout` | `60s` | Upstream response timeout |
| `upstreams[].pass_identity` | `true` | Add `X-Forwarded-User` and `X-Forwarded-Groups` headers |

When `pass_identity` is true, gatekeeper strips any incoming `X-Forwarded-User`/`X-Forwarded-Groups` from the client first, so upstreams can trust these headers. Upstreams must not be reachable except through gatekeeper, or this guarantee is void.

## oidc

| Key | Default | Meaning |
| --- | --- | --- |
| `oidc.issuer` | **required** | Issuer URL; discovery is fetched from `/.well-known/openid-configuration` |
| `oidc.client_id` | **required** | Client ID |
| `oidc.client_secret_file` | **required** | File containing the client secret |
| `oidc.scopes` | `[openid, email, profile]` | Requested scopes |
| `oidc.groups_claim` | `groups` | ID-token claim holding group names, used by `policy` |

The redirect URI to register with your IdP is `https://<any upstream host>/_gatekeeper/callback`.

## session

| Key | Default | Meaning |
| --- | --- | --- |
| `session.secret_file` | **required** | 32+ byte secret used to sign session cookies |
| `session.previous_secret_files` | `[]` | Older secrets still accepted for verification |
| `session.lifetime` | `12h` | Absolute session lifetime |
| `session.cookie_domain` | (host only) | Set to a parent domain to share sessions across upstream hosts |

To rotate the secret without logging everyone out: move the current file path into `previous_secret_files`, point `secret_file` at a new secret, reload, and remove the old entry after `session.lifetime` has passed.

## policy

Rules are evaluated top to bottom; the first match wins. If no rule matches, the request is denied.

| Key | Meaning |
| --- | --- |
| `policy[].upstream` | Upstream `name`, or `*` |
| `policy[].allow_groups` | Groups (from `oidc.groups_claim`) allowed |
| `policy[].allow_emails` | Individual email addresses allowed |
| `policy[].methods` | Optional HTTP methods; default all |

Because the first match wins, put narrow rules (a specific upstream and method) above broad ones (`upstream: "*"`).

## logging

| Key | Default | Meaning |
| --- | --- | --- |
| `logging.level` | `info` | `debug`, `info`, `warn`, `error` |
| `logging.format` | `json` | `json` or `text` |
| `logging.access_log` | `true` | One line per request with user, upstream, status, latency |

`debug` logs ID-token claims; do not enable it in production if claims contain personal data you are not allowed to log.

## Complete example

```yaml
listen:
  tls:
    cert_file: /etc/gatekeeper/tls.crt
    key_file: /etc/gatekeeper/tls.key
upstreams:
  - name: grafana
    host: grafana.internal.example.com
    target: http://10.0.3.12:3000
  - name: admin
    host: tools.internal.example.com
    path_prefix: /admin
    target: http://10.0.3.20:8080
oidc:
  issuer: https://login.example.com
  client_id: gatekeeper
  client_secret_file: /etc/gatekeeper/oidc-secret
session:
  secret_file: /etc/gatekeeper/session-secret
  cookie_domain: internal.example.com
policy:
  - upstream: admin
    allow_groups: [platform-admins]
  - upstream: "*"
    allow_groups: [employees]
```
