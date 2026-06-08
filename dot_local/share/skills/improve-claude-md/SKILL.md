---
name: improve-claude-md
description: Evaluate and improve a project's CLAUDE.md using strategies from recognized agentic coding practitioners. Use when asked what to put in CLAUDE.md, when setting up a new project, or when CLAUDE.md has grown too large.
---

# Improve CLAUDE.md

Analyze the current CLAUDE.md and recommend additions, removals, and structural changes based on the "operating system" principle and evidence-backed best practices.

## When to use

- User asks "what should go in CLAUDE.md?" or "how do I improve my CLAUDE.md?"
- CLAUDE.md has grown beyond ~200 lines and adherence is dropping
- Starting a new project and want to set up CLAUDE.md correctly from the start
- CLAUDE.md contains a mix of facts, procedures, and automated-check prose

## When NOT to use

- User is debugging a command or tool mentioned in CLAUDE.md — help with the underlying command instead; do not run the improve-claude-md workflow
- User wants to edit the content of `.claude/settings.json`, hooks, or skills directly — those are covered by other skills
- User is asking about a non-Claude AI coding assistant (Copilot, Cursor rules, etc.) — the file structure and principles differ

## Quick start

```
/improve-claude-md
```

Reads the current `CLAUDE.md`, evaluates it against the five-layer model, and outputs a concrete plan with sections to add, remove, or relocate.

## Core Principles

| Principle | Source |
|-----------|--------|
| CLAUDE.md describes how the project world operates — not procedures, but facts | Okhlopkov (boringbot) |
| Target under 200 lines per file; longer files reduce adherence | Claude Code official memory docs |
| Marginal value of behavioral rules drops sharply above 4 rules | Yanli Liu empirical study |
| Deterministic enforcement belongs in hooks; procedures belong in skills; CLAUDE.md holds only always-loaded facts | Official docs + practitioner consensus |

## The Five-Layer Model (Okhlopkov)

| Layer | Location | Role |
|-------|----------|------|
| facts | CLAUDE.md | Project-specific reality held in every session |
| procedures | .claude/skills/ | Multi-step workflows invoked on demand |
| enforcement | hooks / settings.json | Deterministic rules that run regardless of Claude's decisions |
| isolation | .claude/agents/ | Subagents that protect main context from noise |
| connectivity | MCP servers | External tools and API connections |

## Workflow

### Step 1: Assess the current state

Read and record:
- Current CLAUDE.md content (line count, section structure, each rule)
- Hooks already configured in `.claude/settings.json` (avoid duplicating enforced rules in prose)
- Skills already in `.claude/skills/` (avoid duplicating procedures in CLAUDE.md)

### Step 2: Identify high-value content to add

Evaluate candidates in priority order:

1. **Constraints that prevent irreversible mistakes**
   - Generated code that gets overwritten on regeneration (mark as do-not-edit with the regeneration command)
   - Source-of-truth files (e.g., "API changes start from `openapi.yaml`")

2. **Tech stack with versions**
   - Framework, ORM, test library exact versions
   - Prevents wrong library choices (e.g., using the wrong ORM or the wrong major version)

3. **Architecture layer model**
   - Which layer owns what logic and which directory it lives in
   - Enables correct placement of new code without asking

4. **Non-obvious project conventions**
   - Rules a reader cannot infer from the code itself (e.g., mandatory parallelism in tests, naming conventions)

### Step 3: Identify content to remove or relocate

| Content | Correct location | Reason |
|---------|-----------------|--------|
| Multi-step procedures (e.g., API change flow, git workflow) | skills | CLAUDE.md holds facts, not workflows |
| Automated checks (e.g., `git diff --check`, `pnpm lint` before commit) | hooks / settings.json | Deterministic enforcement, not prose |
| Command reference lists (e.g., "how to run tests") | Taskfile.md / docs/ | Reference documentation |
| Directory- or file-type-scoped rules | Nested CLAUDE.md | Lazy loading reduces context overhead |
| Generic best practices | Remove entirely | Already in Claude's training |

Generic best practices to remove (Claude already knows these):
- "prefer `const` over `let`", "write descriptive variable names", "keep functions small"
- "always write tests for new features", "avoid `any` type", "use async/await"
- "write descriptive commit messages", "create a branch from main"
- Any rule that applies to virtually every TypeScript/JavaScript/Python project

### Step 4: Identify nested CLAUDE.md candidates

Rules that apply only to a specific subdirectory belong in `<subdir>/CLAUDE.md`, not the root file. They load only when Claude reads files in that directory (VILA-Lab lazy loading pattern).

Typical split candidates:
- `backend/CLAUDE.md`: Go test patterns, ORM conventions, migration workflow
- `frontend/CLAUDE.md`: Component structure, linter config, test runner patterns

### Step 5: Present the improvement plan

Output concrete Markdown for:
- Sections to add (with full content)
- Content to remove or relocate (with destination)
- Nested CLAUDE.md candidates (with proposed content)
- Estimated line count after changes (must be under 200)

## Verification Criteria

After applying improvements, confirm:

- `wc -l CLAUDE.md` is under 200
- Asking Claude to "edit a generated file directly" → Claude cites the constraint and refuses
- Asking "how do I add a new API endpoint?" → Claude starts from the spec/source-of-truth file
- Asking Claude to use a wrong library → Claude corrects to the version stated in the tech stack
