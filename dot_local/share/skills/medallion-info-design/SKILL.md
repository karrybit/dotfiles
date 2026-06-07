---
name: medallion-info-design
description: Use when designing data or information workflows before analysis, reporting, study review, agent handoffs, or automation, especially when raw collected data must be separated from normalized data and action-ready outputs using Bronze/Silver/Gold layers while respecting privacy, credentials, copyright, or terms-of-service constraints.
---

# Medallion Info Design

Use this skill before collecting or transforming external-service data, local records, logs, study histories, research ledgers, or other reusable information.

The goal is to prevent analysis notes, dashboards, and action lists from becoming the only source of truth. Design the data flow first, then collect and transform.

For the source pattern, read [references/medallion-architecture.md](references/medallion-architecture.md) when the task needs more than a quick Bronze/Silver/Gold split.

## Workflow

1. Identify the decision or action the user ultimately wants.
2. Define the source system and access method.
3. Split outputs into three layers:
   - Bronze: policy-filtered raw observations.
   - Silver: normalized, deduplicated, validated records.
   - Gold: action-ready summaries, reviews, dashboards, or task lists.
4. State what must never enter any layer: credentials, secrets, session tokens, unnecessary PII, copyrighted full text, private URLs, or terms-restricted content.
5. Decide the minimum durable schema for Bronze before creating Gold artifacts.
6. Define the Silver transformations: parsing, joins, entity normalization, deduplication, status derivation, and freshness fields.
7. Define Gold consumers: human review files, dashboards, study plans, tickets, reports, or agent handoff notes.
8. Keep layer boundaries visible in file names, directories, tables, or document sections.

## Layer Rules

- Bronze is not "save everything." It is the least transformed data that is safe and allowed to retain.
- Silver is where records become comparable. It should not add review opinions unless they are explicit derived fields.
- Gold is where prioritization and interpretation belong. It should be reproducible from Bronze and Silver where practical.
- If the user starts from a review, recommendation, or dashboard, ask what Bronze/Silver source should support it before implementing.
- If access requires authentication, use the normal user-approved interface and do not store credentials, cookies, tokens, or password-derived state.
- If a site or source restricts scraping, automation, or content reuse, keep acquisition inside allowed interfaces and store only allowed minimal metadata.

## Output Shape

When planning or implementing, provide:

- Bronze source and retention policy.
- Silver schema and transformation rules.
- Gold consumers and update cadence.
- Safety exclusions.
- First small slice to validate the pipeline.
