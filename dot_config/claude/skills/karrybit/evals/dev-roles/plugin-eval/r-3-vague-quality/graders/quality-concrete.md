---
type: llm
---
Facts about the case. The requester's quality wishes were "速くて" (fast) and "データが大量でも落ちない" (does not fail on large data), with no numbers. The repository does not give a target time or a data size for an export.

The text under judgment is the reply, which drafts requirements.

PASS if each of the two wishes becomes checkable: either a condition with a scenario and a number (a data size or row count, a time limit, what the user observes when it succeeds or fails), marked as a guess when the reply chose the number, or a question to the requester that asks for that number or scenario.

FAIL if "fast" or "does not fail on large data" remains only as an adjective in a requirement or acceptance criterion (速い, 高速, 大量でも安定, スケーラブル) with neither a number nor a question asking for one.
