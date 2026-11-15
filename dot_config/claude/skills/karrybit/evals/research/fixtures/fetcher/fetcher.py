import os

RETRY_LIMIT_DEFAULT = 3


def retry_limit():
    value = os.environ.get("FETCHER_RETRY_LIMIT")
    if value is None:
        return RETRY_LIMIT_DEFAULT
    return int(value)


def fetch(url, get):
    for attempt in range(retry_limit()):
        try:
            return get(url)
        except OSError:
            if attempt == retry_limit() - 1:
                raise
