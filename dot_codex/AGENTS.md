# AGENTS.md

## Claude-related instruction files

- When creating or editing Claude-related instruction files, including `CLAUDE.md` and `CLAUDE.local.md`, reference other local instruction files with Claude Code's `@` file-reference syntax.
- Prefer `Follow the instructions in @AGENTS.md.` over prose-only references such as `Follow the instructions in AGENTS.md`.
- Do not duplicate the full contents of `AGENTS.md` into `CLAUDE.md` unless explicitly requested.
- If a Claude-related file points to another local instruction file, use a relative `@` reference that is meaningful from that file's directory.

## Chezmoi-managed files

- When a target file appears to be managed by chezmoi, do not edit the live target file directly as the durable change.
- First run `chezmoi update`.
- Then edit the corresponding source file in the chezmoi source repository.
- Commit and push the source change with Git.
- After the source change has been pushed, run `chezmoi apply` to update the live file.
- If `chezmoi apply` fails because the chezmoi state database or another managed path is permission-gated, rerun the same apply command with the required approval rather than changing the target path or flags.

## Artifact reconciliation

- Before committing work that created new files, inventory newly created files and classify them as canonical, draft, merged, or deletion candidates.
- Do not delete draft or obsolete-looking files automatically; report candidates with evidence unless the user explicitly requests cleanup.
- Keep only current effective guidance in instruction files. Move rationale or superseded discussion to commit messages, PR notes, or a dedicated decision log when needed.

## User-scoped agent scripts

- Reusable but project-specific or write-once-run-later scripts for Codex, Claude, or other agents belong under `$XDG_DATA_HOME/agent-scripts/`.
- The stable directory root is managed by chezmoi as `dot_local/share/agent-scripts/`, but arbitrary files below that root are not managed by chezmoi unless explicitly requested.
- Put directory-specific operating rules in `$XDG_DATA_HOME/agent-scripts/AGENTS.md`.
- Do not add agent script directories to `PATH` by default. Invoke scripts by explicit file path.
- Agent scripts must not depend on the caller's current working directory. Resolve paths from the script location, environment variables, or explicit arguments.
- Runtime outputs, logs, scraped intermediates, and other disposable state belong under `$XDG_STATE_HOME/agent-scripts/` or, if `XDG_STATE_HOME` is unset, `$HOME/.local/state/agent-scripts/`.
