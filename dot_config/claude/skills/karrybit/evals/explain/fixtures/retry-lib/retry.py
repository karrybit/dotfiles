"""Retry a call with exponential backoff and full jitter."""
import random
import time

MAX_ATTEMPTS = 3
BASE_DELAY = 0.5
MAX_DELAY = 8.0


class RetryError(Exception):
    """Raised when every attempt failed; `last` holds the final exception."""

    def __init__(self, last):
        super().__init__(f"gave up after {MAX_ATTEMPTS} attempts: {last!r}")
        self.last = last


def backoff(attempt):
    """Seconds to wait after failed attempt number `attempt` (0-based)."""
    return random.uniform(0, min(MAX_DELAY, BASE_DELAY * 2 ** attempt))


def retry(call, retry_on=(ConnectionError, TimeoutError), sleep=time.sleep):
    """Return call(), retrying only when it raises one of `retry_on`.

    Any other exception propagates at once, without a retry.
    """
    for attempt in range(MAX_ATTEMPTS):
        try:
            return call()
        except retry_on as exc:
            if attempt == MAX_ATTEMPTS - 1:
                raise RetryError(exc) from exc
            sleep(backoff(attempt))
