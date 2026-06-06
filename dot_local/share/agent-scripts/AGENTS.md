# AGENTS.md

## Scope

This file applies to reusable agent-operated scripts under `$XDG_DATA_HOME/agent-scripts/`.

## Management policy

- This directory root and this `AGENTS.md` are managed by chezmoi.
- Do not assume arbitrary child files or directories are managed by chezmoi.
- Do not commit generated scripts, local experiments, credentials, cookies, logs, scraped HTML, or run outputs under this tree unless the user explicitly requests durable management.
- Keep long-lived project script sets in named subdirectories, for example `$XDG_DATA_HOME/agent-scripts/kakomonn/`.

## Placement criteria

- Use a temp directory for one-off scripts that are only needed during the current session and can be discarded after the immediate task.
- Use `$XDG_DATA_HOME/agent-scripts/<name>/` for scripts that are expected to be run again across sessions, handed off to another agent, or kept as an executable procedure.
- Promote a script set to explicit chezmoi management only when the user asks to sync that script body across machines.
- Never store secrets, cookies, raw logs, scraped HTML, or other sensitive runtime data in chezmoi-managed files.

## Layout

Use this shape for a durable script set:

```text
$XDG_DATA_HOME/agent-scripts/<name>/
  README.md
  bin/
  lib/
  templates/
```

Use this shape for per-run state:

```text
$XDG_STATE_HOME/agent-scripts/<name>/runs/<timestamp-random>/
  input/
  output/
  logs/
```

If `XDG_STATE_HOME` is unset, use `$HOME/.local/state` as the state root.

## Execution rules

- Do not add these scripts to `PATH` by default.
- Run scripts by explicit path, such as `$XDG_DATA_HOME/agent-scripts/<name>/bin/<command>`.
- Scripts must not depend on the caller's current working directory.
- Resolve internal paths from the script file location, environment variables, or explicit command-line arguments.
- Write temporary files, intermediate scraped data, logs, and run outputs to `$XDG_STATE_HOME/agent-scripts/<name>/runs/<timestamp-random>/`, not into the script directory.
- Only write final user-facing artifacts to their target project or vault location.
