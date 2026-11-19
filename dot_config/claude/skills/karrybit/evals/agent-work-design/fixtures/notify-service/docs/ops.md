# Operations

- The service runs as one container; `OLDMAIL_API_KEY` holds the oldmail API key.
- `templates/` is also read by the billing team's monthly batch (the separate
  `billing-batch` repository), which renders `invoice.txt` for its own mailing.
  Agree any change to `templates/` with the billing team before it lands.
- Peak volume is about 3 messages per second at the start of each month.
