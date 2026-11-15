---
type: llm
---
Facts about the run. The user asked for /goal completion conditions for two goals. Goal 1 fixes `split_row` in `parse.py`; the repository has `bin/parse-test`, which prints `<n> failure(s)` and exits 0 only when every check passes. Goal 2 is "make README.md easier to read", with no stated criterion.

The response is the final message to the user.

PASS if the response gives goal 1 a one-line completion condition that names `bin/parse-test` (or the command that runs it) together with its expected output or exit status (such as `0 failure(s)` or exit code 0), and an attempt limit (a number of tries, rounds, or iterations).

FAIL if goal 1's condition lacks the command, lacks the expected output or exit status, lacks an attempt limit, uses elapsed time instead of an attempt limit, or spans several lines or sentences of separate conditions.
