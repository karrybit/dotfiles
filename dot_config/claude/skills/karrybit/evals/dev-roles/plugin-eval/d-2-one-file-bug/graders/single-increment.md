---
type: llm
---
Facts about the fixture. The repository is one file, `slug.py`, whose `slugify` matches only `[a-z]+`, so digits are dropped; its tests pass. The fix is a one-line change to the pattern plus a test. Nothing in it is uncertain or crosses a component.

The text under judgment is the reply: a plan for the fix.

PASS if the plan is a single increment (one step of work, which may list its own sub-steps such as "add a failing test, change the pattern, run the tests"), and does not list uncertainties or risks to resolve before the work starts.

FAIL if the plan splits the fix into two or more increments, phases, or stages, or lists uncertainties, risks, or spikes to investigate before fixing.
