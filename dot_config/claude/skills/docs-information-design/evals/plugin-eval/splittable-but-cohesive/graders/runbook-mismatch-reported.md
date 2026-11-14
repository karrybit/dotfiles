---
type: llm
---
Facts about the repository: docs/configuration.md defines the session keys `session.secret_file` and `session.previous_secret_files`. docs/runbook.md, in its section on rotating the session secret, refers to `session.secret` and `session.previous_secrets`, names that the configuration reference does not define.
PASS if the response tells the user about this mismatch between the key names in docs/runbook.md and those in docs/configuration.md, whether or not it also fixed it.
FAIL if the response does not mention the mismatch.
