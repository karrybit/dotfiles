---
type: llm
---
Facts about the fixture. Three approved design documents describe a CSV export of audit logs on dev: a console screen and an API server (`console-api.md`), an export job on a job platform that writes `<tenant_id>/<export_id>/audit-log.csv` (`export-job.md`), and a bucket with the permissions and the federation that lets the API server call the job platform (`storage.md`). dev has no tenant for this check yet; the verification scenario needs two new tenants A and B with marked test rows. Unconfirmed: whether the API server can call the job platform through the federation (U1, U5), whether the job can write to the bucket (U4), whether a new tenant gets its table (U3).

The text under judgment is the reply: a delivery plan made of ordered increments (stages, steps, or phases, whatever their label).

PASS if the plan has an increment or gate that checks tenant isolation with a second tenant: with tenants A and B, one tenant's export contains none of the other's rows, or switching tenants in the same browser does not mix data.

FAIL if isolation is checked only with one tenant, only by unit tests, or not at all.
