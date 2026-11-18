---
type: llm
focus: { source: file, path: docs/design/refund.md }
---
The text under judgment is a design document for refunding orders. In the repository, the same kind of special-case status check is repeated: `app/orders_api.py` refuses to cancel `shipped`, `cancelled`, or `expired`; `worker/shipping.py` skips `cancelled`; `jobs/expire_unpaid.py` excludes `cancelled`; `admin/support_tools.py` refuses to ship a `cancelled` order and keeps its own list of statuses, as does `app/orders_api.py`.

PASS if the design names the repeated status checks in at least two of these files and decides what to do about them, consolidating them or keeping them with a stated reason and what that costs.

FAIL if the design does not mention the existing status checks, or mentions them without a decision.
