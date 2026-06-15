# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [Nix](https://nixos.org/).

- **chezmoi** manages configuration files (what goes in `~/.config/`, `~/.local/`, etc.)
- **Nix** (nix-darwin + home-manager) manages packages and tools

## Directory Structure

```
~/.local/share/chezmoi/       ← source (this repository)
  nix/                        ← Nix flake (packages, Homebrew casks, system config)
    modules/profiles/         ← per-machine profiles (work, private_neo, private_minipc)
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

Agent instructions, skills, and subagents are managed under `dot_config/agents/`,
`dot_local/share/skills/`, and `dot_claude/agents/`. See [AGENTS.md](AGENTS.md)
for how agents interact with this repository.

---

## Usage

### Apply dotfiles to a new machine

#### macOS (`work`, `private_neo`)

```sh
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and apply dotfiles
brew install chezmoi
chezmoi init --apply karrybit/dotfiles
```

`chezmoi init --apply` automatically:

1. Clones this repository to `~/.local/share/chezmoi/`
2. Prompts for machine profile: enter `work` or `private_neo`
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

> **private_neo note:** `nix/modules/profiles/private_neo.nix` contains a
> placeholder hostname (`networking.hostName = "personal-neo"`). Verify the
> actual hostname with `scutil --get LocalHostName` and update the file before
> running `nixr` — nix-darwin will write that value to the system.

#### Linux (`private_minipc`)

No Homebrew. Install chezmoi directly, then follow the same flow.

```sh
# 1. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init --apply karrybit/dotfiles
# When prompted, enter: private_minipc
```

```sh
# 2. Install Determinate Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

```sh
# 3. Apply Nix configuration
# home-manager is not yet on PATH, so run it via nix on first apply:
nix run home-manager -- switch --flake ~/.local/share/chezmoi/nix#private_minipc
```

After the first switch, `home-manager` becomes available on PATH and subsequent
rebuilds can use `nixr` (requires opening a new shell after step 1).

On first launch, Neovim will automatically install plugins via lazy.nvim.

---

### Rebuild Nix configuration

Use `nixr` whenever `nix/` changes (packages added/removed, Homebrew casks updated, etc.).

```sh
nixr           # rebuild and switch
nixr update    # update flake.lock, commit it, then rebuild and switch
nixr rollback  # roll back to the previous generation
nixr list      # list generations
```

`nixr` reads the chezmoi profile and dispatches to the appropriate flake attribute:

| Profile | Flake attribute | Manager |
|---|---|---|
| `work` | `darwinConfigurations.work` | nix-darwin + home-manager |
| `private_neo` | `darwinConfigurations.private_neo` | nix-darwin + home-manager |
| `private_minipc` | `homeConfigurations.private_minipc` | home-manager (Linux) |

`nixr update` runs `nix flake update`, commits the updated `flake.lock`, then
switches. `uppkg` calls it internally to upgrade all Nix-managed packages and casks.

Package changes go in `nix/modules/profiles/<profile>.nix`. See [docs/NIX.md](docs/NIX.md)
for the package management policy, flake structure, and design decisions.

---

### Daily operations

```sh
chezmoi edit --apply ~/.config/zsh/.zshrc  # edit and apply
chezmoi update                              # pull and apply from another machine
```

See [docs/CHEZMOI.md](docs/CHEZMOI.md) for the full chezmoi workflow and status symbol reference.

### Sync and update

```sh
syncup  # pull + apply dotfiles, update all packages, push generated commits
uppkg   # update packages and tools only (no pull/push/apply)
```

### run_onchange scripts

These run automatically during `chezmoi apply` when their tracked content changes.

| Script | Trigger | Action |
|--------|---------|--------|
| `run_onchange_01_rustup_components.sh.tmpl` | `rust/component` changed | `rustup component add` for clippy, rustfmt |
| `run_onchange_02_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` for packages not in nixpkgs |
| `run_onchange_03_claude_settings.sh.tmpl` | Claude settings pkl files changed | Regenerate `~/.config/claude/settings.json` |
| `run_onchange_04_sync-skills.sh.tmpl` | Skills under `dot_local/share/skills/` changed | Symlink each skill into `~/.config/claude/skills/` and `~/.agents/skills/` |

---

## Reference

- [docs/CHEZMOI.md](docs/CHEZMOI.md) — chezmoi 操作、status シンボル
- [docs/NIX.md](docs/NIX.md) — パッケージ管理ポリシー、chezmoi vs Nix 境界、flake 構造、設計原則
- [docs/TMUX.md](docs/TMUX.md) — tmux キーバインド一覧
- [MIGRATION.md](MIGRATION.md) — private_neo への移行手順
