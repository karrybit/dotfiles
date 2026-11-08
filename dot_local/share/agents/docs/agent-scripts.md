# Agent Scripts

Read when: editing files with a script or stream editor, or writing a script
that will run again, be handed to another agent, or be kept as a procedure.

## Editing Files With a Script

- Use a script or stream editor only when the edit cannot be expressed as
  string replacements: replacement text computed per occurrence, or one
  transformation across more sites than can be enumerated.
- Before a script writes to files, count each target pattern's occurrences,
  compare against the expected number, and exit without writing when they
  differ.
- Use editing that reports what it matched.
- Start from a state the change can be undone from: a clean working tree for
  tracked files, an explicit backup otherwise.
- Verify a shell-driven edit by its result, not its exit status: the old
  pattern survives only where intended, the diff touches only the intended
  files and lines, and `git diff --check` passes.

## Placing a Script

- Put a script that processes material of only one repository in that
  repository's `bin/`.
- Put any other script expected to run again across sessions or repositories,
  be handed to another agent, or be kept as an executable procedure under
  `$XDG_DATA_HOME/agents/scripts/`, in a named subdirectory holding `README.md`
  and `bin/`.
- When a pipeline is needed repeatedly as one allowed or sandbox-excluded call,
  add it as a script where this section or the CLAUDE.md scratchpad rule places
  it, and run it as one call.
- Treat that root as chezmoi-managed and the files below it as unmanaged;
  promote a script set to explicit management only when the user asks to sync
  it across machines.

## Running a Script

- Invoke an agent script by its explicit file path, and leave its directory off
  `PATH`.
- Resolve paths in an agent script from the script location, environment
  variables, or explicit arguments, not from the caller's working directory.
- Write runtime outputs, logs, scraped intermediates, and other disposable state
  under `$XDG_STATE_HOME/agents/scripts/` (or `~/.local/state/agents/scripts/`
  when unset).
