# References for maintain-claude-md

Source summaries that inform the skill's principles and limits. Each entry includes the key finding and its instruction implication — why the skill is designed the way it is.

---

## Okhlopkov five-layer model

- **Source**: `https://okhlopkov.com/claude-code-setup-mcp-hooks-skills-2026/` (boringbot / shareuhack fleet guide)
- **Type**: practitioner blog — individual source, not independently reproduced
- **Last checked**: 2026-06-08

**Summary**: Organizes the Claude Code configuration surface into five layers: CLAUDE.md (always-on facts), skills (on-demand procedures), hooks (deterministic auto-enforcement), subagents (context isolation), and MCP servers (connectivity). Practitioners report that backing skills with hooks — so the hook auto-injects the skill when a relevant event fires — raised skill trigger rate from ~20% to ~84% over 200 prompts.

**Instruction implication**: Procedures and enforcement prose do not belong in CLAUDE.md. Moving them to the correct layer (skills or hooks) keeps CLAUDE.md as a compact, always-loaded fact store and makes enforcement deterministic rather than probabilistic.

**Caveat**: Single-practitioner metrics; pages were not deep-read in the 2026-06-08 research pass. Treat as discovery-level until independently confirmed.

---

## Yanli Liu — empirical study on rule count

- **Source**: academic / practitioner study (specific URL not captured in 2026-06-08 research pass)
- **Type**: empirical study

**Summary**: Marginal value of behavioral rules in AI coding instructions drops sharply above approximately 4 rules. Adding more rules beyond this threshold produces diminishing returns and can reduce overall adherence.

**Instruction implication**: Keep the CLAUDE.md rule list short. Prefer a few high-signal, project-specific facts over exhaustive lists. When reviewing content, bias toward pruning rather than adding.

---

## Karpathy — four behavioral rules

- **Source**: practitioner guidance (specific URL not captured in 2026-06-08 research pass)
- **Type**: practitioner post

**Summary**: Effective AI behavioral instructions fit in four rules or fewer. Beyond that threshold, specificity and adherence both decline — the model has more surface to misinterpret, and edge cases between rules create ambiguity.

**Instruction implication**: Corollary to the Yanli Liu finding. When evaluating CLAUDE.md content, flag any rule list exceeding four items as a candidate for aggressive pruning or migration to a skill.

---

## VILA-Lab lazy loading pattern

- **Source**: VILA-Lab research (specific URL not captured in 2026-06-08 research pass)
- **Type**: research finding

**Summary**: Directory-scoped CLAUDE.md files load only when Claude reads files in that directory, reducing per-session context overhead. Rules that apply only to a subdirectory never consume context tokens on unrelated tasks.

**Instruction implication**: Rules scoped to a single directory (backend test patterns, frontend component conventions) belong in `<subdir>/CLAUDE.md`, not the root. The root CLAUDE.md should contain only project-wide facts. This is Phase 2 Step 4 in the maintain-claude-md workflow.

---

## Claude Code official memory documentation

- **Source**: `https://code.claude.com/docs/en/skills` plus Claude Code memory docs
- **Type**: official documentation (Anthropic first-party)
- **Last checked**: 2026-06-08
- **Revalidation trigger**: Claude Code minor version touching skills, memory, or CLAUDE.md behavior

**Summary**: CLAUDE.md is always loaded into every session. Target under 200 lines per file — longer files empirically reduce adherence. Skills are loaded on demand; each skill body has a ~5k token budget, with a 25k combined budget across all active skills. Skills are re-attached after context compaction.

**Instruction implication**: The 200-line limit is not a soft suggestion — it is the primary size constraint for Phase 1 drafts and Phase 2 restructuring. Anything exceeding it should be relocated or removed, not compressed. The skill body itself should stay under ~500 lines to preserve budget for other active skills.

---

## Coding agent research ledger

- **Source**: `/Users/takumikaribe/.local/share/agents/docs/coding-agent-research/ledger.md`
- **Type**: local research ledger (freshly fetched sources as of 2026-06-08)

**Summary**: Full source entries for the official Claude Code skills docs, hooks docs, subagents docs, and Codex manual — each with evidence rating, freshness status, and local applicability notes. Contains the candidate extraction log for hook-backed skills, fresh-context reviewer subagent, and cross-tool SKILL.md portability.

**Instruction implication**: Before updating any principle in this skill, check the ledger for whether the underlying source has a newer check date or a changed status. The ledger is the authoritative cache for this user's research on coding agent configuration.
