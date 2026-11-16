---
type: llm
---
Facts about the fixture. Three approved design documents describe a CSV export of audit logs on dev: a console screen and an API server (`console-api.md`), an export job on a job platform that writes `<tenant_id>/<export_id>/audit-log.csv` (`export-job.md`), and a bucket with the permissions and the federation that lets the API server call the job platform (`storage.md`). dev has no tenant for this check yet; the verification scenario needs two new tenants A and B with marked test rows. Unconfirmed: whether the API server can call the job platform through the federation (U1, U5), whether the job can write to the bucket (U4), whether a new tenant gets its table (U3).

The text under judgment is the reply: a delivery plan made of ordered increments (stages, steps, or phases, whatever their label).

PASS if an increment that makes the API server actually call the job platform (a job run started by the API server, observed on dev) comes before the increment that builds out the export job's real logic (reading the table and writing the CSV).

FAIL if the job's logic is built before or together with the first real call from the API server, or the call is first exercised only in a final end-to-end increment.
