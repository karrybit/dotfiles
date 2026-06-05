---
name: audit-dotfiles-bootstrap
description: Audit whether this chezmoi dotfiles repository can bootstrap or update a new machine reliably. Use when reviewing chezmoi init --apply behavior, run_onchange scripts, personal and work profiles, required commands, portability, secret exposure, or first-run failure risks. This is an investigation and reporting workflow; do not modify files unless the user separately requests implementation.
---

# Audit Dotfiles Bootstrap

Assess the repository as if it were being applied on a clean supported machine. Report evidence, severity, and practical remediation options without changing files.

## Audit Areas

1. Entry points:
   - `README.md`
   - `.chezmoi.toml.tmpl`
   - `.chezmoiignore`
   - `run_onchange_*.tmpl`
2. Profiles:
   - Confirm `personal` and `work` references resolve.
   - Identify files required only on one profile or machine.
3. Dependency order:
   - Determine which commands exist before each `run_onchange_` script runs.
   - Check that missing optional tools are handled intentionally.
4. Portability:
   - Review Darwin/Linux guards, shell assumptions, hard-coded paths, and XDG defaults.
5. Safety:
   - Check for credentials, machine-local state, destructive cleanup, and unintended target deletion.
6. Documentation:
   - Compare documented bootstrap steps and managed behaviors with the implementation.

## Verification Commands

Prefer read-only checks:

```sh
git status --short
chezmoi data --format json
chezmoi managed
chezmoi status
chezmoi execute-template --file <template-file>
```

Use `bash -n` or `zsh -n` for scripts with the corresponding interpreter. Do not run `chezmoi apply`, `chezmoi init --apply`, `syncup`, `uppkg`, or package-manager commands during an audit.

## Report Format

Lead with findings ordered by severity. For each finding, include:

- The affected file and line.
- The concrete first-run or update failure mode.
- The profile or platform affected.
- A focused remediation option.

If no issues are found, state that clearly and list checks that could not be performed.
