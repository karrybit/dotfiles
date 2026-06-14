# Repository Instructions

## Chezmoi Source Repository

- This repository is the chezmoi source tree for user dotfiles.
- Make durable changes in source paths such as `dot_config/...`, not in live
  target paths such as `~/.config/...`.
- Use `chezmoi source-path`, `chezmoi target-path`, and `chezmoi managed` when
  the source-to-target mapping is unclear.
- Preserve unrelated live differences and user-authored uncommitted changes.

## Source-Only Files

- Keep repository-only instructions and documentation listed in `.chezmoiignore`.
- Place directory-specific operating rules in the narrowest applicable
  `AGENTS.md`.
- Do not place directory-specific instructions in the repository root.

## Known Permission-Gated Operations

- For `chezmoi apply` in this environment, request the required approval on the
  first attempt instead of first producing the known
  `chezmoistate.boltdb: operation not permitted` failure.
- For known Git index writes in this chezmoi source repository, such as
  `git add` and `git commit`, request the required approval on the first
  attempt instead of first producing `.git/index.lock` permission failures.

## Verification

- After changing chezmoi-managed paths or `.chezmoiignore`, verify that the
  intended files are managed or ignored as expected.
- Interpret unrelated existing live differences separately and report them
  without changing them.

## Documentation

- Review the relevant README when a change affects documented behavior,
  configuration layout, package management, or common operations.
- Nix design decisions (profile-per-package principle, chezmoi vs Nix boundary,
  package policy) are documented in `docs/NIX.md`.

## Agent Skills and Extensions

- Shared user-level agent instructions are in `dot_config/agents/AGENTS.md`.
  Codex reads them via the generated `~/.codex/AGENTS.md`; Claude Code via
  `~/.config/claude/CLAUDE.md`.
- Shared skills live under `dot_local/share/skills/`. `run_onchange_04_sync-skills.sh.tmpl`
  symlinks each into `~/.config/claude/skills/` and `~/.agents/skills/` on apply.
  Adding a skill requires only one directory under `dot_local/share/skills/`;
  no per-agent symlink entries are needed.
- Repository-specific skills live under `.agents/skills/` and are source-only
  (listed in `.chezmoiignore`).
- Claude Code subagents are under `dot_claude/agents/` and deploy to `~/.claude/agents/`.
- Managed skills must include `PROVENANCE.md`. Record installed extensions in
  `~/.local/share/agents/docs/agent-extensions-ledger.md`. Installing via a
  Codex or Claude Code command does not make an extension chezmoi-managed unless
  its source artifact or setting is added to this repository.
- Agent source summaries belong under `~/.local/share/agents/docs/`; only
  explicitly allowlisted summaries are chezmoi-managed.
- Agent-operated scripts belong under `~/.local/share/agent-scripts/`; only
  explicitly allowlisted script sets are chezmoi-managed.

## Nix Package Management Design

### Profile-per-package principle

Each profile (`nix/modules/profiles/*.nix`) declares its own complete package
list independently. Do **not** move packages into `home/common.nix` to avoid
duplication across profiles. Two profiles sharing a tool is coincidence, not a
contract. See `docs/NIX.md` for rationale and consequences.

`home/common.nix` exists only for home-manager framework settings
(`home.stateVersion`, `programs.home-manager.enable`). It must not contain
packages.
