---
name: production-audit
description: Use when asked whether an app, feature, release, or PR is production-ready, what could break in production, or what must be fixed before launch. Build the audit from local evidence and user-approved runtime checks without uploading repository data to external scanners.
---

# Production Audit

## When to Use

Use this skill when the user asks:
- "Is this ready to ship / launch / go live?"
- "What could break in production?"
- "What do we need to fix before release?"
- "Can you do a pre-launch review / post-merge audit?"
- "What did we miss before deploying?"

Covers: pre-launch reviews, post-merge checks, release readiness assessments, deployed URL smoke checks, and retrospective "what went wrong?" analyses.

## When NOT to Use

Do not invoke this skill when the request is primarily:
- **Code correctness or style review** → use `code-review` skill instead
- **Active bug diagnosis with reproduction steps** → use `diagnose` skill instead
- **Security audit only** → use `security-review` skill instead
- **Legal, financial, medical, or compliance certification** → out of scope entirely

If a production-audit request uncovers a bug requiring root-cause investigation, hand off to `diagnose` for that specific defect rather than continuing under this skill.

This is engineering triage, not a legal, financial, medical, or compliance certification.

## Audit Scope (Confirm First)

Before gathering evidence, clarify:
1. **Target**: which branch, tag, PR number, or deployed URL is under review.
2. **Release type**: first-ever launch, incremental feature, hotfix, or infrastructure change.
3. **User approval**: confirm before running any credentialed or mutating commands.

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

Required fields (always present):

```text
Production audit: <score>/100, <band>, because <top risk in one phrase>.

Blockers (required if score < 70, else omit if empty):
- <specific finding — file/line/endpoint where known>

High-value fixes (required; list at least one unless score >= 85):
- <finding with evidence location>

Evidence checked (required; list every source inspected):
- <file, URL, command, or document>

Evidence missing (required; omit section only if nothing relevant was skipped):
- <what would change the score if available>

Next action (required; one concrete step the team should take first):
- <owner if known>: <action>
```

Band labels: `blocked` (0-49) | `risky` (50-69) | `launchable with caveats` (70-84) | `strong` (85-100).

## Source

Distilled from the ECC `production-audit` workflow, reviewed on 2026-06-06. The local version keeps the local-evidence approach and avoids external audit services by default.
