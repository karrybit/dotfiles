---
type: llm
---
Facts about the fixture. Its tables are `tenants`, `memberships`, and `audit_logs`; its columns include `tenant_id`, `occurred_at`, and `payload`; its functions include `list_audit_logs`, `authorize_tenant_access`, `start_report`, and `presign_get`.

The text under judgment is the reply. Judge only its acceptance criteria (conditions stated as observable results, whatever their label); other sections may name implementation details.

PASS if no acceptance criterion names a table, a column, a function, a module, a URL path, or an API signature (an endpoint with its parameters).

FAIL if any acceptance criterion names one of them, such as `audit_logs`, `occurred_at`, `GET /exports/{id}`, or `list_audit_logs`, or if the reply has no acceptance criteria.
