# Repository Instructions

## Chezmoi Source Repository

- This repository is the chezmoi source tree for user dotfiles.
- Make durable changes in source paths such as `dot_config/...`, not in live
  target paths such as `~/.config/...`.
- Use `chezmoi source-path`, `chezmoi target-path`, and `chezmoi managed` when
  the source-to-target mapping is unclear.
- Preserve unrelated live differences and user-authored uncommitted changes.
- Editing source in a git worktree does not change what `chezmoi apply` reads:
  its source directory is `~/.local/share/chezmoi`, the main checkout, so an
  apply from a worktree deploys the main checkout's older content. Push as
  usual, then run `chezmoi update && chezmoi apply` from the main checkout once
  the change has merged.

## Source-Only Files

- Keep repository-only instructions and documentation listed in `.chezmoiignore`.
- Place directory-specific operating rules in the narrowest applicable
  `AGENTS.md`.
- Do not place directory-specific instructions in the repository root.

## Known Permission-Gated Operations

- For `chezmoi apply` in this environment, request the required approval on the
  first attempt instead of first producing the known
  `chezmoistate.boltdb: operation not permitted` failure.
- `pkl eval` fails under the command sandbox: JNA cannot write to the system temp
  directory and the command emits a Java stack trace instead of JSON, so a
  downstream `jq` reports a parse error rather than the real cause. Run it with
  `_JAVA_OPTIONS="-Djava.io.tmpdir=$TMPDIR -Djava.util.prefs.userRoot=$TMPDIR"`
  instead of disabling the sandbox.

## Verification

- Verify changes with `chezmoi apply --dry-run --verbose` and a fresh login
  shell. This repository deliberately has no test suite.
- After changing chezmoi-managed paths or `.chezmoiignore`, verify that the
  intended files are managed or ignored as expected.
- Interpret unrelated existing live differences separately and report them
  without changing them.

## Documentation

- Review the relevant README when a change affects documented behavior,
  configuration layout, package management, or common operations.
- This repository does not use Nix. `docs/NIX.md` is the one-time procedure
  for uninstalling Nix and nix-darwin from a Mac that still has them.

## Agent Configuration, Skills, and Extensions

- Codex's `~/.codex/config.toml` is partially managed by
  `dot_codex/modify_private_config.toml`. Keep public preferences in that
  modifier, pass machine-local `[projects]` through without recording its
  values in source, and never copy the live file into the repository. Keep the
  `private_` attribute so the target remains mode `0600`.
- Repository instructions are `AGENTS.md` files: this one for the repository
  and `dot_config/nvim/AGENTS.md` for that directory. Claude Code reads them
  only while no `CLAUDE.md`, `.claude/CLAUDE.md`, or `CLAUDE.local.md` exists
  in the working directory or above it, so keep those names out of this tree.
- User-scope instructions stay `dot_config/claude/CLAUDE.md`, deployed to
  `~/.config/claude/CLAUDE.md`: Claude Code has no user-scope `AGENTS.md`.
  No instruction file imports another.
- Skills live under `dot_config/claude/skills/` and deploy straight to
  `~/.config/claude/skills/`; there is no intermediate canonical copy.
  `run_onchange_04_prune-skills.sh.tmpl` removes deployed skills whose source
  entry is gone, which chezmoi does not do on its own. It only removes skills
  recorded in its own manifest, so skills installed by other routes survive.
- Claude Code subagents are under `dot_config/claude/agents/` and deploy to
  `~/.config/claude/agents/`.
- Agent source summaries belong under `~/.local/share/agents/docs/`; only
  explicitly allowlisted summaries are chezmoi-managed.
- Agent-operated scripts belong under `~/.local/share/agents/scripts/`; only
  explicitly allowlisted script sets are chezmoi-managed.
