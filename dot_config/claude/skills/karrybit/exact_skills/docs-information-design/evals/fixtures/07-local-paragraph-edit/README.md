# orbit-client

Python client for the Orbit REST API. Supports Python 3.8+.

## Install

```
pip install orbit-client
```

## Quick start

```python
from orbit import Client

client = Client(api_key="...")
for project in client.projects.list():
    print(project.name)
```

## Authentication

Create an API key in the Orbit dashboard under Settings → API keys and pass it as `api_key`, or set the `ORBIT_API_KEY` environment variable.

For long-running processes, use OAuth instead. Tokens expire and the client handles it. When you create a client with `Client.from_oauth(client_id, client_secret)`, it gets an access token, and that token lasts one hour, but a refresh is done automatically by the client sixty seconds before it expires, unless you passed `auto_refresh=False`, in which case you need to call `client.refresh()` yourself, and if a refresh fails the client raises `AuthError` on the next request rather than at refresh time, so wrap requests if you want to retry.

## Pagination

`list()` methods return an iterator that fetches pages lazily. Pass `page_size` (max 100) to control the page size.

## Pagination

List methods return lazy iterators. The maximum `page_size` is 100.

## Errors

All errors derive from `orbit.OrbitError`. Rate limiting raises `RateLimitError` with a `retry_after` attribute in seconds.
