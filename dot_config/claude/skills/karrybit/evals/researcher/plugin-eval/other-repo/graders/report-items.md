---
type: llm
---
The response is the final message to the user after a research note was written at `notes/retry.md`. The request named no check command and no rules for frontmatter.

PASS if the response has all of: the note's path; a conclusion of a few lines; the claims left unverified (or marked 未確認) with their effect on the conclusion, together with what was left out of scope; what the user should decide (or 「なし」); the tools made with the existing tools searched (or 「なし」); and a list of the files to commit, which names `notes/retry.md`. A line saying there was no check (「なし」) may be present or absent.

FAIL if any of the six is missing, or if the response says it committed the note.
