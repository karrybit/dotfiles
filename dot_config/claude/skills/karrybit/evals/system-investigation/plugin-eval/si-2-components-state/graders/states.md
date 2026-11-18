---
type: llm
---
The text under judgment describes the components of an order service, the state each holds, and how one order's state changes. In the repository, `infra/main.tf` defines three ECS services (`orders-api` with 2 tasks, `orders-relay` with 1, `orders-worker` with 2) and an SQS queue `order-events` with a dead-letter queue `order-events-dlq` after 5 receives. The database holds `orders` (status), `outbox` (`sent_at`), and `processed_events`. `app/orders.py` inserts the order as `pending` together with an outbox row; `app/relay.py` sets the outbox row's `sent_at` after sending it to the queue; `worker/consumer.py` records the `event_id` in `processed_events` and sets the order to `confirmed`.

PASS if the answer names the API, the relay, the worker, the queue with its dead-letter queue, and the database tables, and gives the order's change from `pending` to `confirmed` with the component that makes each change, and the outbox row's `sent_at` set by the relay.

FAIL if the answer misses the relay or the queue, says the API sets `confirmed`, or leaves out who changes each state.
