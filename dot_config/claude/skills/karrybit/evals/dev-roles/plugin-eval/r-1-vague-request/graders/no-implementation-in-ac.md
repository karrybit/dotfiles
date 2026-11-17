---
type: llm
---
Facts about the fixture. The CSV export does not exist yet, so no user or caller depends on any name for it. The repository's internal names, which the tenant's administrators never see, are the tables `tenants`, `memberships`, and `audit_logs`; the columns `tenant_id`, `event_id`, `occurred_at`, `actor`, `action`, and `payload`; the functions `list_audit_logs`, `authorize_tenant_access`, `start_report`, `report_url`, and `presign_get`; the exception classes `PermissionDenied`, `InvalidArgument`, and `NotFound`; the job platform's states `QUEUED`, `RUNNING`, `SUCCEEDED`, and `FAILED`; and the storage key format `<tenant_id>/<report_id>/report.csv`.

The text under judgment is the reply. Judge only its acceptance criteria (conditions stated as observable results, whatever their label); other sections may name internal details.

PASS if every acceptance criterion is written in what a user or caller observes (what they do, what the screen or the downloaded file shows, that a request is refused, a status in the words the user sees such as 完了 or 失敗), and none names one of the internal names above or a new endpoint path or signature. Describing the file's content in plain words (日時、操作した人、操作の内容) is fine.

FAIL if any acceptance criterion names one of the internal names above as an identifier (for example "`occurred_at` の列", "`audit_logs` の行", "`PermissionDenied` になる", "状態が `SUCCEEDED`") or a new endpoint (for example `GET /exports/{id}`), or if the reply has no acceptance criteria.
