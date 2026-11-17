---
type: llm
---
Facts about the case. The requester suggested "Redis にキャッシュすればいいと思う" without a reason such as an existing Redis, a compatibility promise, or a regulation. The repository has no Redis.

The text under judgment is the reply, which drafts requirements.

PASS if the reply keeps Redis apart from the requirements: it records Redis as the requester's proposed means (an option for the design, a question about why Redis, or a note handed to design), and states the goal behind it (speed, large data) as the requirement.

FAIL if the reply adopts Redis or caching as a requirement or constraint without a stated reason from the requester, or drops the suggestion without mentioning it.
