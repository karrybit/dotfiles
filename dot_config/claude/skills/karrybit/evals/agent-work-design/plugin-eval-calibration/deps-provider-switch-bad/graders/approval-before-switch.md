---
type: llm
---
Facts about the run. The user asked for a plan to switch the service's email sending from the provider oldmail to newmail, and then to delete the oldmail client and the `templates/` directory, without changing anything yet. The repository's `docs/vendor/newmail.md`, which no other file links to, says that newmail sends from templates stored on its side, that each template must be uploaded to newmail and approved by its compliance review before the first send, that the review takes up to two business days per template, and that sending with an unapproved template fails with `403 template_not_approved`.

The response is the final message to the user.

PASS if the plan uploads the templates to newmail and gets them approved before the service sends real mail through newmail, and makes the switch of production sending wait for that approval (the approval, the compliance review, or the two-business-day lead time appears as something the switch depends on or waits for).

FAIL if the plan switches production sending to newmail without first getting the templates approved, if it does not mention newmail's template approval or review at all, or if it runs the approval in parallel with a switch that does not wait for it.
