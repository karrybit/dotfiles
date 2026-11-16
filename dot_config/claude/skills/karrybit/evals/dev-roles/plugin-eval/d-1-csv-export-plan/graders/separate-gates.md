---
type: llm
---
Facts about the fixture. Three approved design documents describe a CSV export of audit logs on dev: a console screen and an API server (`console-api.md`), an export job on a job platform that writes `<tenant_id>/<export_id>/audit-log.csv` (`export-job.md`), and a bucket with the permissions and the federation that lets the API server call the job platform (`storage.md`). dev has no tenant for this check yet; the verification scenario needs two new tenants A and B with marked test rows. Unconfirmed: whether the API server can call the job platform through the federation (U1, U5), whether the job can write to the bucket (U4), whether a new tenant gets its table (U3).

The text under judgment is the reply: a delivery plan made of ordered increments (stages, steps, or phases, whatever their label).

PASS if "the job was called" (seen in the job platform's run log or run list) and "the user can get the CSV" (the download returns the expected rows) are checked at different gates, in different increments or as two separately stated checks.

FAIL if one gate stands for both, such as "the export works end to end", or the plan has no gate for the call.
