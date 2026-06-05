---
name: audit-agent-skills
description: Audit collections of agent skills for structural validity, unclear or overlapping triggers, wrong placement, stale instructions, broken assumptions, excessive size, and maintainability risks. Use for periodic skill health checks, pre-release reviews, or recommendations for consolidating and improving skills. This is an investigation workflow; do not modify skills unless the user separately requests implementation.
---

# Audit Agent Skills

Inspect skill collections and report focused improvements without changing them.

## Discover Scope

Identify the roots requested by the user. When unspecified, inspect applicable repository-local and user-global skill roots that are accessible. Read repository instructions before interpreting placement or management rules.

Use `scripts/audit-skills.sh` for the initial structural pass:

```sh
bash <audit-agent-skills>/scripts/audit-skills.sh <skill-root>...
```

The script reports structural errors and maintainability warnings. Treat its output as evidence, not a complete audit.

## Manual Audit

For each skill, assess:

1. Trigger quality:
   - Is the description specific about both capability and invocation context?
   - Could it collide with another skill or trigger on ordinary tasks?
2. Scope and placement:
   - Is the skill repository-local, user-global, or system-provided at the correct scope?
   - Is there an accidental duplicate at another scope?
3. Content quality:
   - Does `SKILL.md` contain only non-obvious reusable procedure?
   - Are detailed references loaded progressively rather than copied into the main file?
   - Are scripts deterministic, parameterized, and tested?
4. Currency:
   - Do named paths, commands, tools, and repository conventions still exist?
   - Do instructions conflict with current `AGENTS.md` or documentation?
5. Validation:
   - Does the official validator pass?
   - Does `agents/openai.yaml` still describe the skill accurately?
   - Are scripts syntax-checked and representative paths executed safely?

For curated or externally sourced skills, distinguish local defects from upstream content. Recommend an upstream refresh or a minimal documented local patch as appropriate.

## Report Format

Lead with findings ordered by severity. Include the skill path, evidence, impact, and smallest remediation. Separate:

- Structural errors that can prevent discovery or execution.
- Trigger and overlap risks.
- Stale or repository-specific assumptions.
- Maintainability warnings.

If no issues are found, state that clearly and list remaining checks or runtime behavior that could not be verified. Do not edit files during an audit-only request.
