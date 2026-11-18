---
type: llm
---
The text under judgment explains why order events go through an outbox table. In the repository, `docs/adr/0002-outbox.md` and the commit "fix: start order processing from an outbox written with the order (ADR-0002)" say: the API used to send the confirmation mail after saving the order; when the mail API was down for 40 minutes on 2026-03-04, 214 saved orders got no mail and had no way to be resent; so the order and its `order.created` event now commit in one transaction, a relay sends the event, and the worker sends the mail. The ADR lists the consequences: events survive an outage of the mail API or the queue, the relay can send a row twice so the worker drops duplicates by `event_id`, and the mail is delayed by the relay's interval.

PASS if the answer gives the 2026-03-04 lost confirmations (or an outage that lost them) as the reason, names the ADR or that commit as its source, and states at least one consequence from the ADR.

FAIL if the answer gives a reason the repository does not record (throughput, decoupling in general) as the fact, or names no source.
