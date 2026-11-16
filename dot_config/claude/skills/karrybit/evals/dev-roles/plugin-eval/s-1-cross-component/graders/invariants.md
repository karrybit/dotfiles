---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
The text under judgment is a design document for exporting a tenant's audit logs as CSV through an asynchronous job, object storage, and a signed URL.

PASS if the document states, as invariants or conditions the design must always hold (any label), both of these:
1. one tenant's audit log rows or files never reach another tenant (through the export, the status, or the download link);
2. a failed or unfinished export is never reported or delivered as a success.

FAIL if either is missing, or appears only as a test idea or a risk without being stated as a condition the design keeps.
