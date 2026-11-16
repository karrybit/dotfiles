---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
Facts about the fixture. The repository already has the API server, a client for an asynchronous job platform (`app/jobs.py`), a client for object storage with signed URLs (`app/storage.py`), and a monthly report feature (`app/reports.py`) that uses both the same way an export would. No requirement asks for a new service.

The text under judgment is the design document.

PASS if the design builds the export on these existing components; new modules, functions, job definitions, or a table inside them are fine.

FAIL if the design adds a new deployable service, a message queue, a new database, a cache server, or a long-running worker process that the existing components could replace, without naming a requirement that needs it.
