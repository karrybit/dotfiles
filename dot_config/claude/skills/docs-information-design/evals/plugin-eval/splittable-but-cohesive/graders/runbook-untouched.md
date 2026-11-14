---
type: regex
target: { source: file, path: docs/runbook.md }
pattern: "^# Operations runbook\\n\\n## Reloading configuration\\n\\nSend `SIGHUP` to the gatekeeper process\\. Invalid configuration is rejected and the previous configuration stays active; check the log for `config rejected`\\.\\n\\n## Rotating the session secret\\n\\nSee `session\\.secret` and `session\\.previous_secrets` in the \\[configuration reference\\]\\(configuration\\.md#session\\)\\.\\n*$"
---
