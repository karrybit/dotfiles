---
type: llm
---
Facts about the fixture. Three approved design documents describe a CSV export of audit logs on dev: a console screen and an API server (`console-api.md`), an export job on a job platform that writes `<tenant_id>/<export_id>/audit-log.csv` (`export-job.md`), and a bucket with the permissions and the federation that lets the API server call the job platform (`storage.md`). dev has no tenant for this check yet; the verification scenario needs two new tenants A and B with marked test rows. Unconfirmed: whether the API server can call the job platform through the federation (U1, U5), whether the job can write to the bucket (U4), whether a new tenant gets its table (U3).

The text under judgment is the reply: a delivery plan made of ordered increments (stages, steps, or phases, whatever their label).

PASS if the first increment (or one of the increments with no predecessor) prepares the dev environment for the check, including creating the verification tenant, and every later increment that runs on dev comes after it.

FAIL if creating the verification tenant or preparing the environment comes after an increment that needs it, or the plan never prepares it.
