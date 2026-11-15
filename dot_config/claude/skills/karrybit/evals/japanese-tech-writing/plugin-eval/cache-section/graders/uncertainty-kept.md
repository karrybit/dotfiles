---
type: llm
focus: { source: file, path: docs/cache.md }
---
Facts about the fixture. The source notes say: each write increments the item's `version` in the same transaction; a reader reads the current `version` and builds the Redis key `item:<id>:v<version>` from it, so it never reads an entry for an older version; old entries are not deleted and expire after a 24-hour TTL, which costs memory; whether a reader can still get a stale value is unresolved, since the logs show one response with an older value after a write and its cause has not been confirmed.

The text is the document after the run. Judge only its 「無効化」 section.

PASS if the section explains why an old entry is never read (the key is built from the current version), states the TTL expiry and its memory cost, and presents the one logged stale response as unconfirmed (its cause unknown, the possibility left open).

FAIL if the section omits the mechanism, omits the TTL or memory cost, drops the logged stale response, asserts that stale reads cannot happen, or states a cause for the logged response as fact.
