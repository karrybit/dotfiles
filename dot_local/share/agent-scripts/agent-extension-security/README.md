# Agent Extension Security

Utilities for reviewing public Codex skills, Claude Code skills, Claude Code
subagents, and plugin-provided agent extensions before installation.

Run the vetting script against a candidate directory:

```sh
$XDG_DATA_HOME/agent-scripts/agent-extension-security/bin/vet-agent-extension /path/to/candidate
```

The script reports risky indicators. Treat its output as a review checklist,
not as proof that an extension is safe.
