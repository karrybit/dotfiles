---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
Facts about the fixture. `app/jobs.py` says a job run moves QUEUED -> RUNNING -> SUCCEEDED or FAILED, the platform retries nothing, and a submit with the same idempotency key returns the existing run.

The text under judgment is a design document for exporting audit logs as CSV through that job platform.

PASS if the document defines the states an export goes through and the transitions on failure: what state the user sees when the job fails, and at least one more failure case among a timeout, a retry or duplicate start, a partial result, and a missing permission.

FAIL if the document describes only the successful path, or names states without saying how a failure moves between them.
