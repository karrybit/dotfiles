# retry

A one-file helper that calls a function again when it fails with a
transient error.

```python
from retry import retry, RetryError

try:
    body = retry(lambda: fetch(url))
except RetryError as e:
    log.warning("fetch failed: %r", e.last)
```

- `retry(call)` tries `call()` up to three times in total.
- Only `ConnectionError` and `TimeoutError` are retried by default; pass
  `retry_on=` to change that. Any other exception is raised at once.
- Between attempts it sleeps a random time between zero and
  `0.5 * 2**attempt` seconds, never more than 8 seconds.
- When the last attempt fails, it raises `RetryError`, whose `last` attribute
  is the exception from that attempt.
- Pass `sleep=` to replace `time.sleep`, for example in tests.
