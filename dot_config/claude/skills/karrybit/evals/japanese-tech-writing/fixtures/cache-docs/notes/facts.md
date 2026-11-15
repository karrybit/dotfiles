# Cache invalidation: facts

- Cache entries live in Redis under the key `item:<id>:v<version>`.
- Every write to an item increments its `version` column in Postgres in the same transaction.
- The version number carries the invalidation signal: a reader reads the current `version` first and builds the key from it, so it never reads an entry written for an older version.
- Old entries are not deleted. They expire after their 24-hour TTL.
- This exposes a memory cost: an item written 100 times in a day keeps up to 100 entries in Redis until they expire.
- Whether a reader can still get a stale value is an open question. The logs from 2026-10 show one response that returned an older value after a write; nobody has confirmed the cause.
