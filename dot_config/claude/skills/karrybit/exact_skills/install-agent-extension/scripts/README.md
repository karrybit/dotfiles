# Agent Extension Security

Utilities for reviewing public Claude Code skills, subagents, and
plugin-provided agent extensions before installation.

From the skill's folder, run the vetting script against a candidate directory:

```sh
scripts/vet-agent-extension /path/to/candidate
```

The script reports risky indicators. Treat its output as a review checklist,
not as proof that an extension is safe.
