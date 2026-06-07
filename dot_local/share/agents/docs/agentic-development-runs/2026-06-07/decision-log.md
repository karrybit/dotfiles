# Agentic Development Decision Log

Date: 2026-06-07

## Decisions

### Use track directories for recurring research

- decision: adopted
- track: agentic-development
- source:
  - `agentic-development-research-index.md`
- reason: Track-level directories keep each research stream's strategy and
  ledger together, while the top-level index remains the cross-track map.
- next_review: When adding a third research track or when the ledger format
  becomes too large for a single Markdown file.

### Store run-level decisions under dated run directories

- decision: adopted
- track: agentic-development
- source:
  - `agentic-development-runs/2026-06-07/`
- reason: Decisions are made per research run, not per source. Dated
  directories make summaries, candidates, and decisions easier to share across
  machines and revisit later.
- next_review: If multiple runs on the same date need separate scopes, split
  the date directory into slugged subdirectories.

### Keep temporary scripts out of docs

- decision: adopted
- track: agentic-development
- source:
  - `dot_config/agents/AGENTS.md`
- reason: Write-once scripts belong in tmp, reusable scripts belong under the
  managed user-scoped agent scripts path, and runtime outputs belong in state
  directories.
- next_review: When a recurring research script is needed.

### Use provided agent surfaces instead of subagent hacks

- decision: adopted
- track: agentic-development
- source:
  - `dot_agents/skills/agentic-development-research/SKILL.md`
  - `dot_claude/skills/agentic-development-research/SKILL.md`
  - `dot_claude/agents/agentic-development-researcher.md`
- reason: Codex supports skills for reusable workflow guidance, while Claude
  Code supports both skills and custom subagents. Emulating unsupported Codex
  subagent behavior with wrapper scripts would create an unreliable hidden
  orchestration layer.
- next_review: When Codex documents a first-class custom subagent or isolated
  delegation surface.

### Keep research subagent source access conservative

- decision: adopted
- track: agentic-development
- source:
  - `dot_claude/agents/agentic-development-researcher.md`
- reason: External official or primary source checks may require permission
  prompts or network approval. The research subagent should not infer missing
  facts when a background run cannot access a source; it should return the
  unverified claim and required access to the main agent.
- next_review: When Claude Code changes background subagent permission
  behavior or when this research workflow adopts a dedicated approved source
  access mechanism.
