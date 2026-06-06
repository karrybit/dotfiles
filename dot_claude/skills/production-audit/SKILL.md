---
name: production-audit
description: Use when asked whether an app, feature, release, or PR is production-ready, what could break in production, or what must be fixed before launch. Build the audit from local evidence and user-approved runtime checks without uploading repository data to external scanners.
---

# Production Audit

Use this skill for pre-launch reviews, post-merge checks, release readiness, deployed URL smoke checks, and "what did we miss?" questions.

Start with local signals:

```sh
git status --short --branch
git log --oneline --decorate -20
git diff --stat origin/main...HEAD
```

Then inspect package scripts, CI, release scripts, deployment files, API routes, webhooks, auth middleware, workers, migrations, rollback notes, env docs, observability, health checks, and launch-critical E2E coverage.

Score as `0-49 blocked`, `50-69 risky`, `70-84 launchable with caveats`, or `85-100 strong`. Cap at `69` for missing sensitive auth, non-idempotent webhooks, unsafe migrations, exposed secrets, or missing rollback for high-impact release. Cap at `84` if CI is not green or the critical path was not tested end to end.

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

Distilled from the ECC `production-audit` workflow, reviewed on 2026-06-06. This local copy keeps the local-evidence approach and avoids external audit services by default.
