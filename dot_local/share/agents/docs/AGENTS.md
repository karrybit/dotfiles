# Agent Docs Cache

## Scope

- This directory stores reusable local summaries of external sources used by
  agents.
- Cache only information that is likely to be reused, such as official
  documentation, standards, maintainer guidance, canonical repository notes, or
  recognized expert practices.
- Do not cache one-off investigation notes unless they are likely to influence
  future decisions.

## Entry Requirements

- Include the source URL or local source path, the date checked, the relevant
  version or context, and the condition that should trigger revalidation.
- Prefer concise summaries and decision-relevant excerpts over raw copied
  content.
- Do not copy long copyrighted passages. Use short quotes only when necessary
  and preserve source attribution.
- Mark stale, superseded, duplicated, or low-value entries as consolidation or
  deletion candidates when encountered.

## Maintenance

- Treat cached docs as a searchable working set, not an append-only archive.
- Consolidate overlapping notes when a single clearer summary preserves the
  useful information.
- Keep runtime outputs, downloaded pages, logs, and scraped intermediates out
  of this directory unless explicitly requested.
