---
type: llm
---
Facts about the fixture. The public names that API callers observe are in `docs/api/exports.md`: the path `GET /v1/tenants/{tenant_id}/exports/{export_id}`, the fields `export_id`, `state`, `created_at`, the state values RUNNING, SUCCEEDED, FAILED, the status codes 200, 403, 404, and the error bodies `permission_denied` and `not_found`. The internal names, which callers never see, are the modules `app/exports.py`, `app/store.py`, `app/authz.py`, `app/errors.py`, the functions `start_export`, `authorize_tenant_access`, and the store's `get` and `add`, the classes `ExportStore`, `Export`, `Session`, and the exception classes `NotFound` and `PermissionDenied`.

The text under judgment is the reply. Judge only its acceptance criteria (conditions stated as observable results, whatever their label); other sections may name internal details.

PASS if no acceptance criterion names one of the internal names above. Naming the public path, fields, state values, status codes, and error bodies is fine.

FAIL if any acceptance criterion names an internal module, function, class, or exception class (for example "`get_export` returns", "`NotFound` is raised", "`ExportStore` holds"), or if the reply has no acceptance criteria.
