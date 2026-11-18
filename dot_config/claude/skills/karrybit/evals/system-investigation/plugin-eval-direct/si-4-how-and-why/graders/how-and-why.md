---
type: llm
---
The text under judgment explains how the relay sends outbox rows and why it sends them that way. In the repository, `app/relay.py` `relay_once` selects up to `BATCH_SIZE = 50` rows whose `sent_at` is null, sends them in one `QueueClient.send_batch` request (`POST .../messages:batch`), then sets their `sent_at`; `run` repeats this every `RELAY_INTERVAL_SECONDS = 7` seconds. The commit "perf: send outbox rows to the queue in batches of 50" says one request per row hit the queue API's limit of 100 requests per second during the 2026-04-28 sale and the outbox backed up for 25 minutes, and that the batch endpoint takes up to 50 messages per request.

PASS if the answer gives both: the batch of up to 50 rows in one request followed by setting `sent_at`, and the reason from that commit (the queue API's request limit hit during the sale, with the backlog).

FAIL if either part is missing, or the reason is given as fact without the commit as its source.
