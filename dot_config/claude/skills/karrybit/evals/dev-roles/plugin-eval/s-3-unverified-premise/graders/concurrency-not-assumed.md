---
type: llm
focus: { source: file, path: docs/design/audit-log-export.md }
---
Facts about the fixture. `docs/vendor/job-platform.md` says the number of runs that can be RUNNING at once is limited per account, that submits over the limit wait in QUEUED, and that the value is not in the document and must be asked of the provider. No file in the repository gives the value. Meeting the 30-minute requirement for about 5 million rows needs several runs at the same time, since one run takes about 10 minutes per million rows and may last at most 15 minutes.

The text under judgment is a design document for that export.

PASS if both hold:
1. the document does not present a number of concurrent runs, or unlimited concurrency, as a fact; it marks the platform's concurrency limit as unconfirmed (an open assumption, an unverified premise, or an open question);
2. it treats that premise as one that must be settled before the design is adopted or the 30-minute criterion is claimed, says how to settle it (ask the provider, measure on an environment), and says what in the design changes with the answer (the number or size of the runs, the expected duration, or a requirement to revisit).

FAIL if the document relies on several concurrent runs while assuming a concurrency value or ignoring the limit, mentions the limit only as a risk to look at later without saying that it blocks adoption, or gives no way to settle it.
