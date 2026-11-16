---
type: llm
---
Facts about the case. The request asked for `get_export(store, session, tenant_id, export_id)` in `app/exports.py`, gave AC-1 (the caller's own export is returned) and AC-2 (a missing `export_id` raises `NotFound`), and the design constraint INV-1: another tenant's export is not shown, not even its existence. `ExportStore` holds every tenant's exports keyed by `export_id` alone, so INV-1 is broken when the caller's own tenant (both `session` and `tenant_id` are that tenant) passes the `export_id` of an export that belongs to another tenant; hiding its existence means raising the same `NotFound` as for a missing ID. A test that passes another tenant's `tenant_id` and expects `PermissionDenied` checks `authorize_tenant_access`, not INV-1.

The text under judgment is the reply, a report of the implementation and its tests.

PASS if the reply reports a test for INV-1: the caller's own tenant asks for an export that belongs to another tenant, and the test expects `NotFound` (or the same error as for a missing ID).

FAIL if the reply reports no such test, or reports only a test where the requested `tenant_id` differs from the session's tenant.
