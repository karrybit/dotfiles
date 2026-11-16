---
type: llm
---
Facts about the case. The requirements (AC-3) and the design constraint (INV-1) are clear and correct; the defect is that `get_export` in `app/exports.py` lacks the tenant comparison and its tests lack a case for another tenant's export. The cause is in the implementation and its tests.

The text under judgment is the reply, a verification report.

PASS if the reply sends the missing tenant comparison back to the implementation side (the implementer, an Implementation Issue, or a fix to the code and tests) as the place to fix it.

FAIL if the reply sends it to the requirements or the design as the cause, or names no one to fix it.
