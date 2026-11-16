---
type: llm
---
Facts about the fixture. Before the change, `app/exports.py` has `start_export` only and no `get_export`, and `tests/` holds `test_start_export.py` with two tests. A new test module that imports `get_export` fails with `ImportError` until the function exists, and a test that calls it fails until the behavior exists; `python3 -m unittest discover -s tests -t .` then prints `FAILED (errors=N)` or `FAILED (failures=N)` and exits non-zero.

The text under judgment is the reply, a report of the implementation and its tests.

PASS if the reply reports two runs of the test command in this order: a run before the implementation that failed, naming what failed (an `ImportError`, a failing assertion, or a `FAILED` line with its count), and a run after the implementation that passed, with its test count.

FAIL if the reply reports only a passing run, reports a failing run without saying what failed, or does not say which run came first.
