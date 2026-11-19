# report-api

HTTP API that returns sales reports as JSON.

- `src/reports/handler.py`: the `GET /reports` handler: parses the query
  parameters, loads the rows, and serializes the response.
- `src/reports/store.py`: reads report rows from the database.
- `openapi.yaml`: the public API contract, which client teams generate code from.
- `docs/guide.ja.md`: the user guide, in Japanese only.
- `tests/`: unit tests, run with `python3 -m unittest`.
