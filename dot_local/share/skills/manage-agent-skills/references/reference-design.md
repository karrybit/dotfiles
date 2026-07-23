# Reference Design

Last checked: 2026-06-07

Use this reference when a skill would benefit from durable knowledge, but that knowledge would make `SKILL.md` too long or too specific.

## Good Reference Candidates

- Official or canonical documentation that constrains correct behavior.
- Domain schemas, field definitions, interface contracts, or vocabulary.
- Provider-specific implementation details that only apply sometimes.
- Security, privacy, compliance, licensing, or terms constraints.
- Examples that are useful but not always needed.
- Source summaries that need freshness tracking.

## Poor Reference Candidates

- General software engineering advice the model already knows.
- One-off facts only relevant to the current conversation.
- Long copied documentation.
- Unverified blog summaries when official docs are available.
- Material that should be a deterministic script or validation command.

## Recommended Structure

Use this compact shape:

```md
# <Topic> Reference

Last checked: YYYY-MM-DD

<One-paragraph purpose>

## Source Summary

- <Short source-grounded point>

## Practical Use

- <How an agent should apply this>

## Sources

- <Source title> <URL>

Revalidation trigger: <When to refresh>
```

## Source Quality

- Prefer official docs and standards for normative behavior.
- Prefer maintainer or implementation-proximate sources for fast-moving tools.
- Use community and practitioner sources for examples, not authority.
- Keep private organization names, credentials, private URLs, and proprietary details out of user-global skills unless explicitly requested.

## SKILL.md Link Pattern

Link references by task:

```md
Read [references/provider.md](references/provider.md) when the task uses that provider.
```

Do not say "read all references first." Progressive loading is part of the skill design.
