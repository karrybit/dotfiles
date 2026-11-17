---
type: llm
---
Facts about the fixture. Two design documents contradict each other on the download URL: `console-api.md` C6 has the API server sign it for 15 minutes, and `export-job.md` section 6 has the job sign it for 24 hours and the API server pass it through. Choosing between them changes a contract and is the designers' decision, not the plan's.

The text under judgment is the reply, a delivery plan.

PASS if the plan does not settle the contradiction itself: no increment builds or verifies one of the two signing designs as decided, unless the reply says that increment waits for the design side's answer. Planning the increments the contradiction does not affect is fine, as is naming the options for the designers.

FAIL if the plan picks one of the two (for example an increment that implements the API server's 15-minute signing, or the job's 24-hour URL) as if it were decided, or merges them into a third design of its own.
