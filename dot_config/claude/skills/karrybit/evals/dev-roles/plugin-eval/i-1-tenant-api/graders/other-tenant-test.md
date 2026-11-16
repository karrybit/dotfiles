---
type: llm
---
Facts about the case. The request asked for `get_export(store, session, tenant_id, export_id)` in `app/exports.py`, where AC-3 says: called by the caller's own tenant (both `session` and `tenant_id` are that tenant) with the `export_id` of an export that belongs to another tenant, it raises `NotFound`. A test that passes another tenant's `tenant_id` and expects `PermissionDenied` checks `authorize_tenant_access`, not AC-3.

The text under judgment is the reply, a report of the implementation and its tests.

PASS if the reply reports a test for AC-3: the caller's own tenant asks for an export that belongs to another tenant, and the test expects `NotFound`.

FAIL if the reply reports no such test, or reports only a test where the requested `tenant_id` differs from the session's tenant.
