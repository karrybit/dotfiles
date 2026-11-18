---
type: llm
---
The text under judgment answers which components a `POST /orders` request passes through until the order confirmation mail is sent. In the repository, `app/api.py` `handle_post_orders` calls `app/orders.py` `create_order`, which writes the order with status `pending` and an `order.created` row in the `outbox` table in one transaction, and the API returns 202. Separately, `app/relay.py` `relay_once` reads up to 50 unsent outbox rows, sends them with `QueueClient.send_batch` over HTTP to the queue, and sets `sent_at`. `worker/consumer.py` `handle_message` skips an `event_id` already in `processed_events`, sets the order to `confirmed`, and calls `EmailNotifier.send_confirmation`, which posts to the mail API over HTTP.

PASS if the answer gives this order: API, the order and outbox write in one transaction, the relay sending to the queue, and the worker confirming the order and sending the mail, with the hand-off from the request to the relay described as asynchronous.

FAIL if the answer says the API sends the mail within the request, leaves out the relay or the queue, or puts the steps in another order.
