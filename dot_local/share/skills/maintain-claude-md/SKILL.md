---
name: maintain-claude-md
description: >
  Full-lifecycle CLAUDE.md maintenance skill. Creates CLAUDE.md when missing,
  restructures it when content is in the wrong layer, and corrects facts that
  have drifted from project reality. Use when CLAUDE.md is absent, bloated,
  or feels out of date.
---

# Maintain CLAUDE.md

Diagnose the current state of a project's CLAUDE.md and apply the appropriate workflow: create from scratch (Phase 1), restructure against the five-layer model (Phase 2), or verify and correct stale facts (Phase 3).

## When to use

- CLAUDE.md does not exist and you want to set up the project correctly from the start
- User asks "what should go in CLAUDE.md?" or "how do I improve my CLAUDE.md?"
- CLAUDE.md has grown beyond ~200 lines and adherence is dropping
- CLAUDE.md contains a mix of facts, procedures, and automated-check prose
- Tech-stack versions or conventions in CLAUDE.md feel out of date compared to the actual code

## When NOT to use

- User is debugging a command or tool mentioned in CLAUDE.md — help with the underlying command instead; do not run the maintain-claude-md workflow
- User wants to edit the content of `.claude/settings.json`, hooks, or skills directly — those are covered by other skills
- User is asking about a non-Claude AI coding assistant (Copilot, Cursor rules, etc.) — the file structure and principles differ

## Quick start

```
/maintain-claude-md
```

Detects which phase applies, then runs the appropriate workflow.

## Core Principles

| Principle | Source |
|-----------|--------|
| CLAUDE.md describes how the project world operates — not procedures, but facts | Okhlopkov (boringbot) |
| Target under 200 lines per file; longer files reduce adherence | Claude Code official memory docs |
| Marginal value of behavioral rules drops sharply above 4 rules | Yanli Liu empirical study |
| Deterministic enforcement belongs in hooks; procedures belong in skills; CLAUDE.md holds only always-loaded facts | Official docs + practitioner consensus |

See `docs/references.md` for source summaries and the reasoning behind each limit.

## The Five-Layer Model (Okhlopkov)

| Layer | Location | Role |
|-------|----------|------|
| facts | CLAUDE.md | Project-specific reality held in every session |
| procedures | .claude/skills/ | Multi-step workflows invoked on demand |
| enforcement | hooks / settings.json | Deterministic rules that run regardless of Claude's decisions |
| isolation | .claude/agents/ | Subagents that protect main context from noise |
| connectivity | MCP servers | External tools and API connections |

## Workflow

### Step 0: Detect phase

Run these checks in order and stop at the first match.

1. Does `CLAUDE.md` exist in the project root?
   - No → **Phase 1 (Bootstrap)**

2. Does `CLAUDE.md` contain any of the following?
   - Multi-step procedures (numbered lists describing how to perform a task)
   - Automated-check prose (e.g., "run `pnpm lint` before committing")
   - Generic best practices (rules that apply to every project of this type)
   - File exceeds 200 lines
   - Yes to any → **Phase 2 (Restructure)**

3. Do any factual claims in `CLAUDE.md` appear inconsistent with the project?
   (version numbers, file paths, scripts, architecture descriptions)
   - Yes → **Phase 3 (Drift-correct)**

4. None of the above → report that CLAUDE.md is well-maintained and exit.

---

### Phase 1: Bootstrap

**Entry condition**: `CLAUDE.md` does not exist.

#### Step 1: Discover project metadata

Read the following to extract exact versions and structure:
- `package.json` (Node.js, framework, test library)
- `go.mod` (Go version, major dependencies)
- `pyproject.toml` or `requirements.txt` (Python version, framework)
- `Makefile` (available commands and conventions)

#### Step 2: Map the directory structure

Run `ls` and a shallow `find` on major subdirectories to identify layer boundaries (e.g., `backend/`, `frontend/`, `packages/`, `cmd/`).

#### Step 3: Read existing automation

Check `.claude/settings.json` for hooks and `.claude/skills/` for skills. Do not duplicate content already enforced or described there.

#### Step 4: Draft CLAUDE.md

Include only these four categories:

1. **Tech stack with exact versions** — prevents wrong library or version choices
2. **Architecture layer model** — which layer owns what logic and which directory it lives in
3. **Source-of-truth constraints** — generated files that must not be edited by hand; spec-first files (e.g., "API changes start from `openapi.yaml`"); migration rules
4. **Non-obvious project conventions** — rules a reader cannot infer from the code itself

Do not include procedures, enforcement prose, or generic best practices.

#### Step 5: Present draft for confirmation

Show the full draft. Do **not** write the file until the user confirms.

---

### Phase 2: Restructure

**Entry condition**: `CLAUDE.md` exists but contains wrong-layer content or exceeds 200 lines.

#### Step 1: Assess the current state

Read and record:
- Current `CLAUDE.md` content (line count, section structure, each rule)
- Hooks already configured in `.claude/settings.json` (avoid duplicating enforced rules in prose)
- Skills already in `.claude/skills/` (avoid duplicating procedures in CLAUDE.md)

#### Step 2: Identify high-value content to add

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

#### Step 3: Identify content to remove or relocate

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

#### Step 4: Identify nested CLAUDE.md candidates

Rules that apply only to a specific subdirectory belong in `<subdir>/CLAUDE.md`, not the root file. They load only when Claude reads files in that directory (VILA-Lab lazy loading pattern).

Typical split candidates:
- `backend/CLAUDE.md`: Go test patterns, ORM conventions, migration workflow
- `frontend/CLAUDE.md`: Component structure, linter config, test runner patterns

#### Step 5: Present the improvement plan

Output concrete Markdown for:
- Sections to add (with full content)
- Content to remove or relocate (with destination)
- Nested CLAUDE.md candidates (with proposed content)
- Estimated line count after changes (must be under 200)

---

### Phase 3: Drift-correct

**Entry condition**: `CLAUDE.md` is well-structured (passes Phase 2 check) but facts may not reflect the current project state.

#### Step 1: Extract factual claims

Read `CLAUDE.md` and list every claim that can be verified against the project: version numbers, file paths, CLI commands, directory names, architecture descriptions, convention statements.

#### Step 2: Verify each claim

| Claim type | Where to verify |
|---|---|
| Library / runtime versions | `package.json`, `go.mod`, `pyproject.toml` |
| File and directory paths | `ls` / `find` on the stated paths |
| CLI commands and scripts | `package.json` scripts, `Makefile` targets |
| Architecture layer descriptions | Actual directory structure |
| Conventions and naming rules | Spot-read 2–3 recent files in the relevant directory |

#### Step 3: Classify findings

- **Stale**: the claim is factually wrong (version differs, path no longer exists)
- **Outdated**: the claim was once true but new code follows a different pattern
- **Missing**: an important project fact exists in the code but is absent from CLAUDE.md

#### Step 4: Present corrections

Show a diff-style summary grouped by classification. Propose targeted edits — do not rewrite sections that remain accurate. Do not write changes until the user confirms.

---

## Verification Criteria

**Phase 1** — after writing the new CLAUDE.md:
- `wc -l CLAUDE.md` is under 200
- File contains only facts (no procedures, enforcement prose, or generic best practices)
- Asking Claude "how do I add a new endpoint?" → Claude starts from the source-of-truth file

**Phase 2** — after applying restructuring:
- `wc -l CLAUDE.md` is under 200
- Asking Claude to "edit a generated file directly" → Claude cites the constraint and refuses
- Asking "how do I add a new API endpoint?" → Claude starts from the spec/source-of-truth file
- Asking Claude to use a wrong library → Claude corrects to the version stated in the tech stack

**Phase 3** — after applying drift corrections:
- Every verifiable claim in CLAUDE.md can be confirmed against the project's current files
- No claim contradicts `package.json`, `go.mod`, or `pyproject.toml` versions
