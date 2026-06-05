# Repository Instructions

## Scope Control

- Follow the exact scope requested by the user.
- When asked only to investigate, explain, assess, review, or identify a cause,
  do not modify files. Report findings, evidence, and possible options instead.
- When asked only for a plan or recommendation, do not implement it.
- Modify files only when the user explicitly requests implementation or
  changes.
- Before modifying files, state what will be changed.
- If the requested scope is ambiguous, investigate first and ask before
  modifying files.

## Repository Changes

- Before creating a requested file, check whether it already exists and inspect
  its contents.
- Reuse or update existing files and conventions when appropriate.
- Preserve unrelated and user-authored uncommitted changes.
- Place instructions in the narrowest applicable `AGENTS.md`.
- Do not place directory-specific instructions in the repository root.

## Verification

- After editing files, run `git diff --check`.
- After changing chezmoi-managed paths or `.chezmoiignore`, verify that the
  intended files are managed or ignored as expected.
- Report checks that could not be run.

## Completion Criteria

- Treat investigation, planning, and implementation as separate request scopes.
- A documentation-affecting configuration change is complete only after the
  relevant README has been reviewed.
- Before creating a file, confirm that an equivalent file does not already
  exist.

## Instruction Maintenance

- When agent behavior causes reusable friction or violates user intent, propose
  the smallest concrete `AGENTS.md` improvement.
- Do not update `AGENTS.md` automatically when reviewing agent behavior.
- Do not add rules for one-off situations unless the impact is significant.
- Write rules with a clear trigger and expected action.
- Prefer verification commands, tests, or hooks over behavioral instructions
  when compliance can be checked mechanically.
- Check proposed rules for duplication or conflicts with existing instructions.
- Apply instruction changes only after user approval.
- Periodically remove outdated, duplicated, or ineffective instructions.
