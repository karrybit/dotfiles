---
type: llm
---
Facts about the run. The user wants three changes to `report-api`, one per agent, as parallel as possible. (a) and (b) both change `GET /reports` in `src/reports/handler.py` and `openapi.yaml`. (c) only creates a new file `docs/guide.en.md`, an English translation of the existing `docs/guide.ja.md`, and touches no file that (a) or (b) changes.

The response is the final message to the user.

PASS if the design starts (c) right away, in parallel with (a) or (b), instead of making it wait for them. A note that the English guide may later need the new parameters, as a follow-up after (a) and (b), is fine as long as the translation itself starts at once.

FAIL if the design makes the translation (c) wait until (a) or (b) finishes, or runs all three one after another.
