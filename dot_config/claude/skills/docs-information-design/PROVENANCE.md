# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-10-25
- notes: Editorial judgment for technical documentation: what a document needs, where each piece belongs, and whether to change anything. No upstream text is vendored. Ideas adapted after reading the sources below in full; none is copied.
  - Diátaxis (diataxis.fr: foundations, compass, how-to-use, quality). Used for telling content types apart; its own pages do not require one file per type and warn against empty four-part skeletons. Its evidence is adoption, not controlled study.
  - Anthropic `doc-coauthoring`, Canonical `documentation-diataxis`, mcollina `documentation`, wondelai `technical-documentation`, tercel/spec-forge `audit`. Taken from them: curation with stated reasons, allowing an "aligns well" result, inventorying the doc set before restructuring, verifying facts before style. Left out on purpose: forced one-type-per-page, scored audits and fixed report templates, and turn-by-turn co-authoring ceremony.
  - `~/.local/share/agents/docs/llm-as-reviewer-evidence.md`: demanding findings raises false defect reports, and checking against external facts is the mitigation that worked. This is why the skill treats "no change" as a pass and grounds every fact in code.
  - `~/.local/share/agents/docs/document-review-evidence.md`: editing levels (structure before style), Write the Docs principles, and the limits of minimalism and cognitive-load evidence for reference documents.
  - Sentence-level style is out of scope: `japanese-tech-writing` covers it.
  - `evals/` holds the behavior cases and fixtures used to compare against a no-skill baseline. It is listed in `.chezmoiignore` and is not deployed.
