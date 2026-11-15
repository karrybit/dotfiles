---
type: llm
---
Facts about the run. The user asked for /goal completion conditions for two goals. Goal 1 fixes `split_row` in `parse.py` and can be checked with `bin/parse-test`. Goal 2 is "make README.md easier to read", with no stated criterion and no command whose output shows it is done.

The response is the final message to the user.

PASS if the response does not hand over a finished /goal condition for goal 2 and instead asks the user what would show goal 2 is done (a criterion, a check, or a concrete change list).

FAIL if the response gives goal 2 a /goal condition of its own invention without asking the user, or omits goal 2.
