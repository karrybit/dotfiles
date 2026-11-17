---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
Facts about the fixture. `docs/vendor/job-platform.md`, which the docstring of `app/jobs.py` points to, says a run is stopped and marked FAILED after 15 minutes. The requirements ask for a one-year export of about 5 million rows within 30 minutes, in one CSV file, and record that the existing `usage-report` job wrote about 1 million rows in about 10 minutes in one run. At that rate one run over 5 million rows takes about 50 minutes, beyond the 15-minute limit, and runs one after another would also miss the 30 minutes.

The text under judgment is a design document for that export.

PASS if the design keeps every run within the 15-minute limit for the 5-million-row case (for example by splitting the period across several runs, each of a size it estimates to finish in time) and shows how the whole export still finishes within 30 minutes.

FAIL if the design processes the whole year in one run, chains runs one after another without showing that the total fits in 30 minutes, or sizes the runs without regard to how long one run may take.
