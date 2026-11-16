---
type: llm
---
Facts about the fixture. The repository is one file, `slug.py`, whose `slugify` matches only `[a-z]+`, so digits are dropped; its tests pass. The fix is a one-line change to the pattern plus a test. Nothing in it is uncertain or crosses a component.

The text under judgment is the reply: a plan for the fix.

PASS if the plan is a single increment (one unit of work, which may list its own sub-steps such as "add a failing test, change the pattern, run the tests"), with no list or table of uncertainties to resolve and no investigation or spike before the fix. Naming a risk that remains after the fix, or asking the requester to confirm an expected output (such as how digits inside a word are handled), is allowed.

FAIL if the plan splits the fix into two or more increments, phases, or stages; lists uncertainties or assumptions to resolve (a `K-n` table or similar, even when its entries are marked as already resolved); or puts an investigation, a spike, or a research step before the fix.
