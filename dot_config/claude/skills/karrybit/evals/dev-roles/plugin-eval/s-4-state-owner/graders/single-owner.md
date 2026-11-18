---
type: llm
focus: { source: file, path: docs/design/refund.md }
---
The text under judgment is a design document for refunding orders. In the repository, four places write `orders.status` directly with their own checks: `app/orders_api.py` `cancel_order`, `worker/shipping.py` `mark_shipped`, `jobs/expire_unpaid.py` `expire_unpaid`, and `admin/support_tools.py` `force_status`.

PASS if the design gives the writes of the order's status, including the new `refunded` transition, to one component or module that decides which transitions are allowed, and has the refund and at least the existing writers it touches change the status through that component.

FAIL if the refund writes the status column with its own check beside the existing writers, or the design leaves who may change the status unstated.
