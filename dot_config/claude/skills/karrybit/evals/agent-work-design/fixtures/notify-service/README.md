# notify-service

Sends transactional email (welcome, invoice) for the shop.

- `src/notify/sender.py`: renders a template from `templates/` and sends it.
- `src/notify/oldmail_client.py`: the client for the current email provider, oldmail.
- `templates/`: one plain-text template per message type.
- `tests/`: unit tests, run with `python3 -m unittest`.
- `docs/ops.md`: how the service is run.
