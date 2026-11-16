---
type: llm
---
The text under judgment is the reply, which drafts requirements for exporting a tenant's audit logs as CSV in a multi-tenant admin console.

An acceptance criterion is a condition stated as an observable result (given a situation and an action, what the user or system observably gets), whatever its label (`AC-1`, 受け入れ条件, Given/When/Then).

PASS if the reply has at least three acceptance criteria, and at least one of them is a concrete example in which a user specifies another tenant's ID or asks for another tenant's data and observably gets no data (a refusal, an error, or an empty result).

FAIL if the reply has fewer than three acceptance criteria, if its criteria are adjectives without observable results ("安全に", "使いやすい"), or if no criterion covers a request for another tenant's ID or data.
