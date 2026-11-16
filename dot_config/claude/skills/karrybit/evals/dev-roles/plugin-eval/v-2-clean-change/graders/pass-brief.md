---
type: llm
---
Facts about the fixture. `get_export` in `app/exports.py` calls `authorize_tenant_access`, raises `NotFound` when the export is missing or belongs to another tenant, and `tests/test_get_export.py` covers the caller's own export, a missing ID, and another tenant's export; all five tests pass. AC-1 to AC-3 and INV-1 hold.

The text under judgment is the reply, a verification report.

PASS if the verdict is a pass (PASS or 合格), and the reply's statement of what was checked to conclude there is no problem takes at most three lines or three bullet points; tables listing each criterion's status are not counted toward those lines.

FAIL if the verdict is not a pass, or the justification for the pass runs longer than three lines or three bullet points.
