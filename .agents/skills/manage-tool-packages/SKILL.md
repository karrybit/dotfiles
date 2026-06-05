---
name: manage-tool-packages
description: Add, remove, update, or diagnose developer tools and packages managed by this dotfiles repository. Use for Homebrew Brewfiles, aqua manifests, Rust components or cargo packages, package update functions, and profile-specific personal or work package changes. Do not use for application configuration changes unrelated to package installation.
---

# Manage Tool Packages

Choose the existing package manager and profile scope before changing manifests.

## Select The Owner

| Tool type | Source file |
| --- | --- |
| macOS applications, Homebrew formulae, casks, taps | `dot_config/homebrew/Brewfile.<profile>` |
| Versioned CLI tools managed by aqua | `dot_config/aquaproj-aqua/aqua.<profile>.yaml` |
| rustup components | `dot_config/rust/component` |
| Globally installed cargo binaries | `dot_config/rust/package` |

Use the active profile from `chezmoi data --format json` when the request concerns the current machine. Ask before changing both `personal` and `work` unless the requested scope clearly requires both.

## Workflow

1. Read applicable instructions and inspect `git status --short`.
2. Search all manifests for an existing equivalent package.
3. Inspect the corresponding updater and `run_onchange_` script:
   - Homebrew: `__update_homebrew` and `run_onchange_01_homebrew.sh.tmpl`
   - aqua: `__update_aqua` and `run_onchange_02_aqua.sh.tmpl`
   - Rust: `__update_rust_tools`, `run_onchange_03_rustup_components.sh.tmpl`, and `run_onchange_04_cargo_packages.sh.tmpl`
4. State the intended manifest and profile changes before editing.
5. Preserve the existing file format and ordering conventions.
6. Do not run `uppkg`, `syncup`, `brew upgrade`, `aqua update`, or other networked updates unless explicitly requested.
7. Review `README.md` when package-management behavior or bootstrap behavior changes.

## Verification

Run focused syntax or parser checks when available, then:

```sh
git diff --check
chezmoi managed <affected-target>
chezmoi status
git status --short
```

Do not treat unrelated generated package updates or live differences as part of the requested change.
