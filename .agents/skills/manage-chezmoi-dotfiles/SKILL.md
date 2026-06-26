---
name: manage-chezmoi-dotfiles
description: Safely implement and verify general changes in this chezmoi-managed dotfiles repository. Use when adding, removing, renaming, templating, ignoring, or otherwise changing chezmoi-managed paths, especially when mapping between source paths such as dot_config and live paths such as ~/.config. Prefer a more specific package, zsh, or bootstrap skill when its scope fully covers the request.
---

# Manage Chezmoi Dotfiles

Work from the chezmoi source repository and preserve its source-to-target mapping.

## Workflow

1. Read the applicable `AGENTS.md` files and inspect `git status --short`.
2. Confirm whether an equivalent source or target file already exists.
3. Identify both paths before editing:
   - Source example: `dot_config/foo/config`
   - Target example: `~/.config/foo/config`
   - Use `chezmoi source-path`, `chezmoi target-path`, and `chezmoi managed` when uncertain.
4. Inspect `.chezmoiignore`, nearby templates, and profile-specific files before choosing a location.
5. State the intended edits before modifying files.
6. Keep unrelated user changes intact and edit source files, not deployed target files.
7. Review the relevant README when the change affects documented behavior or configuration.

## Chezmoi Conventions

- Map a leading dot in a target filename or directory to a `dot_` source prefix.
- Use `.tmpl` only when the file needs chezmoi template data or conditionals.
- Keep source-only documentation listed in `.chezmoiignore`.
- Do not run `chezmoi apply`, `chezmoi update`, `upup`, or package updates unless the user explicitly requests the live or remote side effect.
- Do not manage secrets, generated runtime state, histories, caches, or machine-local credentials.

## Verification

Always run:

```sh
git diff --check
git status --short
```

After changing managed paths or `.chezmoiignore`, also run:

```sh
chezmoi managed <target-path>
chezmoi status
chezmoi diff <target-path>
```

Interpret unrelated existing live differences separately and report them without changing them.
