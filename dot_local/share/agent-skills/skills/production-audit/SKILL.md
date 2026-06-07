---
name: production-audit
description: Use when asked whether an app, feature, release, or PR is production-ready, what could break in production, or what must be fixed before launch. Build the audit from local evidence and user-approved runtime checks without uploading repository data to external scanners.
---

# Production Audit

Use this skill for pre-launch reviews, post-merge checks, release readiness, deployed URL smoke checks, and "what did we miss?" questions.

This is engineering triage, not a legal, financial, medical, or compliance certification.

## Evidence Order

Start with local signals:

```sh
git status --short --branch
git log --oneline --decorate -20
git diff --stat origin/main...HEAD
```

Then inspect the surfaces that actually exist:

- package scripts, CI workflows, release scripts, Docker or deployment files
- API routes, webhooks, auth middleware, background workers, cron jobs
- database migrations, seed/backfill scripts, rollback notes
- environment variable documentation and startup validation
- observability, health checks, logs, dashboards, and error reporting
- E2E coverage for launch-critical user paths

Use browser or HTTP checks only for URLs in scope. Avoid credentialed actions unless the user provides a safe test account and approves the action.

## Risk Lenses

Check:

- security and auth: server-side authorization, secrets, CORS, CSRF, uploads, rate limits
- data integrity: migrations, rollback, idempotency, backfills, tenant boundaries
- payments and webhooks: signature verification, replay handling, duplicate delivery, live/test credential separation
- operations: clean checkout startup, required env vars, health checks, rollback, incident owner
- user experience: mobile, loading, empty, error, permission-denied, and recovery states

## Scoring

Use scores to prioritize, not to claim certainty:

- `0-49`: blocked
- `50-69`: risky
- `70-84`: launchable with caveats
- `85-100`: strong from available evidence

Cap at `69` if sensitive auth is missing, webhooks are non-idempotent, required migrations cannot run safely, secrets are exposed, or no rollback exists for a high-impact release.

Cap at `84` if CI is not green or the launch-critical path was not tested end to end.

## Output Format

```text
Production audit: <score>/100, <band>, because <top risk>.

Blockers:
- ...

High-value fixes:
- ...

Evidence checked:
- ...

Evidence missing:
- ...

Next action:
- ...
```

## Source

Distilled from the ECC `production-audit` workflow, reviewed on 2026-06-06. The local version keeps the local-evidence approach and avoids external audit services by default.
