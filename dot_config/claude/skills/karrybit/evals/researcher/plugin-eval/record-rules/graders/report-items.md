---
type: llm
---
The response is the final message to the user after a meeting note was written at `source/meeting/2026-11-17-weekly-sync.md`. The request named the check `bin/check-note`, whose passing output is `check-note: 0 problem(s)`, and said the requester commits and keeps the task records.

PASS if the response has all of: the note's path; a conclusion of a few lines; the unverified claims (or a statement that there are none) together with what was left out of scope; what the user should decide (or 「なし」); the tools made with the existing tools searched (or 「なし」); the last line of the check; and a list of the files to commit, which names the note.

FAIL if any of the seven is missing, or if the response says it committed the note or updated a task or decision record.
