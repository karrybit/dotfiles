---
type: llm
focus: { source: file, path: README.md }
---
PASS if README.md still explains why --strict is off by default: spreadsheet exports commonly end with an empty line (or trailing blank row) that strict mode would reject.
FAIL if that explanation is absent, or the README only restates what the flag does without saying why it is off by default.
