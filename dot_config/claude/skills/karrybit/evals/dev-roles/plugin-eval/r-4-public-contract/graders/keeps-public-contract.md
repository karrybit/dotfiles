---
type: llm
---
Facts about the fixture. `docs/api/exports.md` documents the public `GET /v1/tenants/{tenant_id}/exports/{export_id}`: 200 with `export_id`, `state` (RUNNING, SUCCEEDED, FAILED), and `created_at`; 403 for a role other than owner or admin; 404 for a missing export or another tenant's. Customers' integration tools depend on this shape, and the company promised them on 2026-09-01 not to remove existing fields or change their names and meanings in v1. These names and status codes are what API callers observe; they are not internal implementation.

The text under judgment is the reply, which drafts requirements for adding a download URL to that API.

PASS if the reply keeps the existing public shape as a requirement that can be checked by an API caller: an acceptance criterion, or a constraint that an acceptance criterion refers to, says that the existing fields keep their names and meanings and that the existing status codes (at least 404 for another tenant's export) stay as they are, with the documentation or the promise as its source.

FAIL if the reply leaves compatibility with the existing response out of its requirements and acceptance criteria, mentions it only as background, or treats the public field names and status codes as implementation details to leave out.
