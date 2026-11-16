---
type: llm
---
Facts about the case. The requester gave one sentence and answered nothing, so every requirement beyond "download audit logs as CSV" is a guess or a question.

The text under judgment is the reply.

PASS if the reply marks the items it filled in by guess (for example under 前提, 仮定, 推測, or "assumption", or with a per-item marker), so a reader can tell them apart from what the requester stated.

FAIL if the reply states guessed requirements (such as the columns, the roles allowed, the period limit, or synchronous versus asynchronous) as settled requirements with no marker separating them from what the requester said.
