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
