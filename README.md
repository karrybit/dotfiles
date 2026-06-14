# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [Nix](https://nixos.org/).

- **chezmoi** manages configuration files (what goes in `~/.config/`, `~/.local/`, etc.)
- **Nix** (nix-darwin + home-manager) manages packages and tools

## Directory Structure

```
~/.local/share/chezmoi/       ← source (this repository)
  nix/                        ← Nix flake (packages, Homebrew casks, system config)
    modules/profiles/         ← per-machine profiles (work, personal_neo, personal_minipc)
  dot_config/                 ← configuration files → ~/.config/
  dot_local/                  ← local data/bin → ~/.local/

~/.config/                    ← live configuration files
~/.config/agents/             ← shared user-level agent instructions
~/.local/share/agents/docs/   ← reusable local agent source summaries
~/.local/share/skills/        ← shared user-level agent skills (canonical)
~/.agents/skills/             ← Codex skill entrypoints (per-skill symlinks → ~/.local/share/skills/*)
~/.config/claude/skills/      ← Claude Code skill entrypoints (per-skill symlinks → ~/.local/share/skills/*)
```

`chezmoi apply` deploys source → live. The `dot_` prefix is converted to `.` (e.g. `dot_config/` → `~/.config/`).

Shared user-level agent instructions are managed under
`dot_config/agents/AGENTS.md`. Codex receives those rules through the generated
`~/.codex/AGENTS.md`; Claude Code imports them from
`~/.config/claude/CLAUDE.md`.

Shared user-level agent skills are managed under `dot_local/share/skills/`.
`run_onchange_06_sync-skills.sh.tmpl` automatically symlinks each skill into
`~/.config/claude/skills/` (Claude Code) and `~/.agents/skills/` (Codex)
whenever the skill set changes. Adding a skill requires only one directory
under `dot_local/share/skills/`; no per-agent symlink entries are needed.
3rd party skills installed via `claude` or `apm` land directly in those
directories and are not affected. Restart Codex or Claude Code if a newly
applied skill is not detected.

Repository-specific skills live under `.agents/skills/` and remain source-only
through their entries in `.chezmoiignore`.

User-level Claude Code subagents are managed under `dot_claude/agents/` and
deploy to `~/.claude/agents/`.

Some user-level agent workflows are distilled from external expert repositories
and vendored as instruction-only skills. These do not install the source
repository's plugins, hooks, MCP servers, installers, or auto-update behavior.
Managed skills must include `PROVENANCE.md`, and installed or enabled skills,
plugins, MCP servers, hooks, and subagents should be recorded in
`~/.local/share/agents/docs/agent-extensions-ledger.md`. Installing an extension
with a Codex or Claude Code command does not make it chezmoi-managed unless the
source artifact or setting is added to this repository.

Reusable agent source summaries are stored under
`~/.local/share/agents/docs/`. That directory's `AGENTS.md` is managed by
chezmoi; reusable summaries are managed only when explicitly allowlisted in
`.chezmoiignore`, and other cached summaries remain local and unmanaged.

Reusable agent-operated scripts live under `~/.local/share/agent-scripts/`.
Only explicitly allowlisted script sets are managed by chezmoi.

`cowaxa` is a user-level CLI for evaluating Codex skills with scenario-based
tests and with-skill versus without-skill baseline comparisons.

---

## Usage

### Apply dotfiles to a new machine

```sh
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and apply dotfiles
brew install chezmoi
chezmoi init --apply karrybit/dotfiles
```

`chezmoi init --apply` automatically:

1. Clones this repository to `~/.local/share/chezmoi/`
2. Prompts for machine profile: enter `work`, `personal_neo`, or `personal_minipc`
3. Runs `chezmoi apply` to deploy live files
4. Executes `run_onchange_` scripts (Rust components, Claude settings, skills sync)

```sh
# 3. Install Determinate Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 4. Apply Nix configuration (installs all packages and Homebrew casks)
nixr
```

`nixr` selects the flake configuration based on the chezmoi profile set in step 2.

On first launch, Neovim will automatically install plugins via lazy.nvim.

---

### Rebuild Nix configuration

Use `nixr` whenever `nix/` changes (packages added/removed, Homebrew casks updated, etc.).

```sh
# Rebuild and switch to the new configuration
nixr

# Roll back to the previous generation
nixr rollback

# List generations
nixr list
```

`nixr` maps the chezmoi profile to the appropriate flake attribute:

| Profile | Flake attribute | Manager |
|---|---|---|
| `work` | `darwinConfigurations.work` | nix-darwin + home-manager |
| `personal_neo` | `darwinConfigurations.personal-neo` | nix-darwin + home-manager |
| `personal_minipc` | `homeConfigurations.personal-minipc` | home-manager |

Package changes go in `nix/modules/profiles/<profile>.nix`. Each profile declares
its own complete package list independently — do not move packages into shared
modules to avoid duplication across profiles.

---

### Edit dotfiles source and apply to machine

```sh
# Edit source using the live path (applies automatically on save)
chezmoi edit --apply ~/.config/zsh/.zshrc

# Or apply manually
chezmoi edit ~/.config/zsh/.zshrc
chezmoi diff
chezmoi apply

# Commit and push
chezmoi git add -- .
chezmoi git commit -- -m "..."
chezmoi git push
```

---

### Add a new file to chezmoi management

```sh
# Copy a live file into the source
chezmoi add ~/.config/foo/bar

# Verify the source was created
chezmoi status

# Commit and push
chezmoi git add -- .
chezmoi git commit -- -m "..."
chezmoi git push
```

---

### Pull and apply changes from GitHub

Use this to apply changes pushed from another machine.

```sh
chezmoi update
```

---

### Check status and diff

```sh
# List differences between source and live
chezmoi status

# Show detailed diff (what chezmoi apply would change)
chezmoi diff

# Diff for a specific file
chezmoi diff ~/.config/zsh/.zshrc
```

`chezmoi status` symbols:

| Symbol | Meaning |
|--------|---------|
| `M` | Source is newer than live (will be updated on apply) |
| `A` | Exists in source but not in live (will be created on apply) |
| `D` | Removed from source (will be deleted from live on apply) |
| `R` | `run_onchange_` script is pending execution |

---

### Sync and refresh everything

```sh
syncup
```

Pulls and applies the latest dotfiles, updates packages and tools, pushes any
generated dotfile commits, then applies the final source state.

### Update packages and tools only

```sh
uppkg
```

Runs package and tool updates without pulling, pushing, or applying dotfiles.

---

## run_onchange Scripts

These scripts run during `chezmoi apply` only when their tracked files change.

| Script | Trigger | Action |
|--------|---------|--------|
| `run_onchange_01_rustup_components.sh.tmpl` | `rust/component` changed | `rustup component add` for clippy, rustfmt |
| `run_onchange_02_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` for packages not in nixpkgs (cargo-upgrades) |
| `run_onchange_03_claude_settings.sh.tmpl` | Claude settings pkl files changed | Regenerate `~/.config/claude/settings.json` |
| `run_onchange_04_sync-skills.sh.tmpl` | Skills added/removed under `dot_local/share/skills/` | Symlink each skill into `~/.config/claude/skills/` and `~/.agents/skills/` |

Homebrew casks and CLI packages are managed by Nix (`nix/modules/profiles/<profile>.nix`),
not by `run_onchange_` scripts.

## Package Management Policy

| Category | Manager |
|---|---|
| CLI tools and development packages | Nix (`home.packages`) |
| macOS GUI apps with self-update or system extensions | Homebrew cask (declared in nix profile) |
| Rust toolchain | `rustup` (nix-managed binary, components via run_onchange_03) |
| Cargo packages not in nixpkgs | `cargo install` via run_onchange_04 |
| `aqua`, `chezmoi` | Homebrew (permanent: nixpkgs-unlisted / bootstrap dependency) |

**Why macOS GUI apps stay as Homebrew casks:** The Nix store is read-only, so
any app that tries to update itself in-place (Obsidian, DBeaver, Chrome, etc.)
will fail silently or crash. Apps that require kernel/system extensions
(Karabiner-Elements uses DriverKit) must be installed via cask because Nix
cannot register system extensions. Apps whose nixpkgs package only targets
Linux (Ghostty) will cause evaluation errors on macOS.

---

## Maintaining Nix Configuration

### Profile-per-package principle

Each profile (`nix/modules/profiles/<profile>.nix`) declares its own **complete**
package list independently. Do **not** move packages into `nix/modules/home/common.nix`
or any shared module to avoid duplication across profiles.

Two profiles sharing a tool is coincidence, not a contract. Shared packages:
- impose a false declaration that every environment needs that tool
- require touching multiple files to add or remove a package from one profile
- make divergence between profiles look like something to fix rather than something natural

`home/common.nix` exists only for home-manager framework settings
(`home.stateVersion`, `programs.home-manager.enable`).

### share-only packages (no binary)

Some nixpkgs packages install only into `share/` with no `bin/` directory
(e.g. `antidote`, shell plugin collections). Adding these to `home.packages`
is not enough: with `useUserPackages = true`, the package's `share/` directory
is **not** merged into the user environment's `share/`.

Use `home.file` to create a stable symlink directly to the nix store path:

```nix
home.file.".local/share/antidote/antidote.zsh".source =
  "${pkgs.antidote}/share/antidote/antidote.zsh";
```

The symlink path (`~/.local/share/antidote/antidote.zsh`) is then stable across
rebuilds and can be sourced directly from shell config.

### chezmoi vs Nix responsibility boundary

| Managed by | Examples |
|---|---|
| chezmoi | `~/.config/zsh/`, `~/.config/nvim/`, `~/.config/tmux/`, `~/.config/karabiner/` |
| Nix | All binaries, Homebrew casks, tmux plugins, starship/git/direnv settings |

Shell configuration files (`.zshrc`, `.zshenv`, functions, widgets) remain
chezmoi-managed. Migrating them into `programs.zsh` would require
`programs.zsh.enable = true`, which conflicts with the chezmoi-managed `.zshrc`.
The `eval "$(direnv hook zsh)"` and `eval "$(starship init zsh)"` lines in
`.zshrc` call nix-managed binaries and do not need to be moved into Nix.
