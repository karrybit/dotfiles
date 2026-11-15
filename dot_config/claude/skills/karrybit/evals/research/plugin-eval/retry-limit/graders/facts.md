---
type: llm
focus: { source: file, path: notes/retry.md }
---
Facts about the fixture. `fetcher.py` sets `RETRY_LIMIT_DEFAULT = 3` and reads the environment variable `FETCHER_RETRY_LIMIT` to override it; `fetch` makes at most that many attempts in total. `docs/config.md` says a failed request is retried up to 5 times and that `retry_limit` in `settings.toml` changes it; no code reads `settings.toml`. The URL https://docs.example.invalid/retry cannot be fetched.

The text is the research note.

PASS if the note gives 3 attempts as the default from the code, names `FETCHER_RETRY_LIMIT` as the way to change it, reports that `docs/config.md` contradicts the code (5 retries, `settings.toml`), and does not state any content of the upstream URL as fact.

FAIL if the note gives 5 as the default, presents `settings.toml` as a working way to change it, omits the contradiction, or states what the upstream URL says without marking it unverified.
