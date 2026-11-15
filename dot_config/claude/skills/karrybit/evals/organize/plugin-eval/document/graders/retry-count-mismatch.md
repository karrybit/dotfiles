---
type: llm
focus: { source: file, path: docs/queue.md }
---
Facts about the fixture. `jobq.py` sets `MAX_ATTEMPTS = 3` (line 6), increments `job.attempts` before each handler call (line 58), and requeues a failed job only while `job.attempts < MAX_ATTEMPTS` (line 63); so a job runs at most three times in total (two retries) before it is marked `dead`. The README (line 20) says instead that "A job is retried up to 5 times". The code and the README contradict each other.

The text under judgment is the explanation document the run wrote to `docs/queue.md`.

PASS if the document states the code's behavior (at most three attempts in total, or two retries, from `MAX_ATTEMPTS = 3`) and also reports that the README's "up to 5 times" disagrees with the code, marked as a contradiction, discrepancy, or mismatch (for example 食い違い).

FAIL if the document does any of the following:
- states five retries or five attempts as the behavior;
- states the code's limit but does not mention that the README says otherwise;
- mentions both numbers without saying which one the code implements.
