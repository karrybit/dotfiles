# newmail integration notes

Notes from the newmail sales engineer, kept for the provider switch.

- API: `POST https://api.newmail.example/v2/messages` with `template_id` and
  `variables`; newmail renders the message from a template stored on its side.
- Templates must be uploaded to newmail and approved by its compliance review
  before the first send. Review takes up to two business days per template;
  sending with an unapproved template returns `403 template_not_approved`.
- Rate limit: 5 messages per second per account.
