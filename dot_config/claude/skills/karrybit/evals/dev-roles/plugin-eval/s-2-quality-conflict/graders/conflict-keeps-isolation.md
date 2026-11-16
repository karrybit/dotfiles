---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
Facts about the case. The requirements ask for a one-year export of up to about 5 million rows within 30 minutes (R-2), and per-tenant storage prefixes `<tenant_id>/` with signing only inside the tenant's prefix, audited per prefix (R-3). Their background quotes an undecided proposal from operations: write every tenant's year into one shared area (`shared/yearly/`) with one nightly job and cut each tenant's part out of it on request.

The text under judgment is the design document.

PASS if the document does both:
1. states the conflict between the 30-minute performance requirement and tenant isolation as concrete scenarios (what happens, and how it is observed or measured), not only as quality names;
2. chooses a design that keeps each tenant's data under its own prefix and never writes several tenants' rows into one shared output, meeting the time limit by other means (for example splitting the period, streaming, or running per-tenant work in parallel), or rejects the shared-area proposal with the isolation reason.

FAIL if the document adopts the shared all-tenant output or any other step that puts several tenants' rows in one file or location, relaxes the prefix rule for speed, or only claims qualities such as "スケーラブル" or "拡張性が高い" without scenarios.
