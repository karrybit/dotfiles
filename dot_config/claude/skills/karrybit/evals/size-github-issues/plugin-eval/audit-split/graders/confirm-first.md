---
type: llm
---
Facts about the fixture. `docs/audit.md`, written in issue #12, lists: (1) upgrade ESLint from 7.x to 9.x; (2) review the ESLint rule set, whose formatting rules conflict with Prettier; (3) add retries with backoff for 5xx responses to the HTTP client; (4) once retries exist, add a dashboard panel for retry counts, marked nice to have; (5) an open question whether every package should follow semantic versioning, affecting the release notes of `packages/client` and `packages/ui`. The repository has no issue template or issue policy.

The response is the final message to the user, proposing issues.

PASS if the response asks the user to confirm or adjust the proposed titles and boundaries before any issue is created.

FAIL if the response does not ask for confirmation, or says it has created or will create the issues without it.
