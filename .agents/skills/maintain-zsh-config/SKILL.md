---
name: maintain-zsh-config
description: Implement, review, or diagnose zsh configuration in this dotfiles repository. Use for zsh functions, widgets, abbreviations, startup files, PATH and environment setup, tool initialization, OS-specific shell behavior, and update helpers under dot_config/zsh. Do not use for unrelated shell scripts outside the zsh configuration.
---

# Maintain Zsh Config

Follow the repository's startup phases and autoload conventions.

## Choose The Location

| Purpose | Location |
| --- | --- |
| Earliest bootstrap that sets `ZDOTDIR` | `dot_zshenv` |
| Non-interactive environment and PATH setup | `dot_config/zsh/zshenv.d/*.zsh` |
| Interactive startup and plugin loading | `dot_config/zsh/dot_zshrc` |
| Manually installed tool initialization | `dot_config/zsh/env.d/*.zsh` |
| Autoloaded user commands and helpers | `dot_config/zsh/functions/` |
| OS-specific autoloaded functions | `dot_config/zsh/functions/darwin/` or `linux/` |
| ZLE widgets | `dot_config/zsh/widgets/` |
| Shared sourced helpers | `dot_config/zsh/lib/` |

## Workflow

1. Read applicable instructions and inspect `git status --short`.
2. Trace how the affected file is sourced or autoloaded before editing.
3. Search for existing helpers and naming conventions.
4. State the intended edits before modifying files.
5. Keep startup work minimal:
   - Put environment-only setup in `zshenv.d`.
   - Put interactive commands in `.zshrc` or `env.d`.
   - Avoid unconditional calls to optional commands unless existing conventions require them.
6. Use `__require_commands` for user functions that require commands.
7. Keep private helpers prefixed with `__`.
8. Preserve `personal` and `work` profile behavior and Darwin/Linux branches.

## Verification

Run syntax checks on every changed zsh file:

```sh
zsh -n <changed-file>
```

For autoloaded functions, test loading in an isolated zsh when practical. Also run:

```sh
git diff --check
chezmoi managed <affected-target>
chezmoi status
git status --short
```

Do not source the user's full interactive configuration merely to test a narrow change when that would start tmux or invoke external tools.
