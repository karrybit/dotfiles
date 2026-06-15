---
name: manage-tool-packages
description: Add, remove, update, or diagnose developer tools and packages managed by this dotfiles repository. Use for Nix profile packages, Homebrew casks/formulae declared in Nix, rustup components, and cargo packages not in nixpkgs. Do not use for application configuration changes unrelated to package installation.
---

# Manage Tool Packages

Choose the existing owner and profile scope before changing manifests. Packages
are managed by Nix (nix-darwin + home-manager); only a few bootstrap formulae and
self-updating GUI casks stay in Homebrew, declared from Nix. See
[docs/NIX.md](../../../docs/NIX.md) for the full policy.

## Select The Owner

| Tool type | Source file |
| --- | --- |
| CLI tools and development packages | `nix/modules/profiles/<profile>.nix` → `home.packages` |
| macOS GUI apps that self-update in place or need system extensions | `nix/modules/profiles/<profile>.nix` → `homebrew.casks` |
| Permanent Homebrew formulae (bootstrap or nixpkgs-unlisted, e.g. `aqua`, `chezmoi`) | `nix/modules/darwin/homebrew.nix` → `brews`/`taps` |
| rustup components (e.g. clippy, rustfmt) | `dot_config/rust/component` |
| Globally installed cargo binaries **not** packaged in nixpkgs | `dot_config/rust/package` |

Profiles are `work`, `private_neo`, and `private_minipc`. Use the active profile
from `chezmoi data --format json` (`.profile`) when the request concerns the
current machine. Each profile declares its **complete** package list
independently — do not move packages into a shared module to reduce duplication
(profile-per-package principle; see docs/NIX.md). Ask before changing more than
one profile unless the requested scope clearly requires it.

## Workflow

1. Read applicable instructions and inspect `git status --short`.
2. Search the profiles and manifests for an existing equivalent (`home.packages`,
   `homebrew.casks`, `homebrew.nix` brews, `dot_config/rust/component`,
   `dot_config/rust/package`). Prefer nixpkgs (`nix search nixpkgs <keyword>`)
   before adding a cask or a cargo/rustup entry.
3. Understand how each owner is applied:
   - Nix packages and Homebrew casks/formulae: applied by `nixr` (rebuild) or
     `nixr update` (also bump `nix/flake.lock`). `homebrew.onActivation.cleanup =
     "zap"` removes any Homebrew package not declared in Nix.
   - rustup components: `run_onchange_01_rustup_components.sh.tmpl` runs
     `rustup component add` on `chezmoi apply` when `dot_config/rust/component`
     changes.
   - cargo packages: `run_onchange_02_cargo_packages.sh.tmpl` runs
     `cargo install` on `chezmoi apply` when `dot_config/rust/package` changes.
4. State the intended manifest and profile changes before editing.
5. Preserve the existing file format, grouping comments, and ordering conventions.
6. Do not run `nixr`, `nixr update`, `nix flake update`, `uppkg`, `syncup`,
   `brew upgrade`, or other networked updates unless explicitly requested.
7. Review `README.md` and `docs/NIX.md` when package-management or bootstrap
   behavior changes.

## Verification

Nix files imported by the flake must be tracked by git before checks can see
them. A PostToolUse hook in `.claude/settings.json` auto-runs `git add -N` on
new `.nix` files under `nix/` after Edit/Write, so flake checks pick them up
without a manual step. If a new file is still invisible (hook not loaded), stage
it manually with `git add -N nix/path/to/changed-file.nix`.

```sh
task nix:check        # nix flake check (statix, deadnix, state-version, hostname)
```

Then:

```sh
git diff --check
chezmoi managed <affected-target>   # for dot_config/rust/* changes
chezmoi status
git status --short
```

Do not treat unrelated generated package updates or live differences as part of
the requested change.
