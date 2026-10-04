# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

- **chezmoi** manages configuration files (what goes in `~/.config/`, `~/.local/`, etc.)
- **Homebrew + mise** manage packages and tools on macOS
- **Nix + home-manager** manage packages and tools on `private_minipc`

## Directory Structure

```
~/.local/share/chezmoi/       ← source (this repository)
  nix/                        ← private_minipc Nix flake
  dot_codex/                  ← partial Codex configuration → ~/.codex/
  dot_config/                 ← configuration files → ~/.config/
  dot_local/                  ← local data/bin → ~/.local/

~/.config/                    ← live configuration files
~/.config/claude/CLAUDE.md    ← user-level agent instructions
~/.local/share/agents/docs/   ← reusable local agent source summaries
~/.local/share/agents/scripts/ ← reusable agent-operated scripts
~/.config/claude/skills/      ← user-level agent skills
```

`chezmoi apply` deploys source → live. The `dot_` prefix is converted to `.` (e.g. `dot_config/` → `~/.config/`).

Agent instructions, skills, and subagents are all managed under
`dot_config/claude/`. See [CLAUDE.md](CLAUDE.md) for how agents interact with
this repository.

Codex's `~/.codex/config.toml` is partially managed by
`dot_codex/modify_private_config.toml`. Chezmoi enforces the public user
preferences declared there while passing machine-local state such as
`[projects]` through unchanged. Its absolute paths and values therefore never
enter this repository. The `private_` source attribute keeps the live file at
mode `0600`.

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
# 3. Install Homebrew and mise-managed packages
brew bundle install --file ~/.config/homebrew/Brewfile.<profile>
MISE_CONFIG_FILE="$HOME/.config/mise/config.<profile>.toml" mise install
```

On first launch, Neovim will automatically install plugins via lazy.nvim.

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

After the first switch, `home-manager` becomes available on PATH for subsequent rebuilds.

On first launch, Neovim will automatically install plugins via lazy.nvim.

---

### Rebuild Nix configuration (`private_minipc` only)

Use the following command whenever `nix/` changes (packages added/removed, etc.).

```sh
home-manager switch --flake ~/.local/share/chezmoi/nix#private_minipc
```

| Profile | Flake attribute | Manager |
|---|---|---|
| `private_minipc` | `homeConfigurations.private_minipc` | home-manager |

On Linux, `upup` calls `__uppkg`, which runs `nix flake update`, commits the
updated `flake.lock`, then switches. macOS updates Homebrew and mise without
invoking Nix.

Linux package changes go in `nix/modules/profiles/private_minipc.nix`. See [docs/NIX.md](docs/NIX.md)
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
upup    # pull + apply dotfiles, update all packages, push generated commits
```

### run_onchange scripts

These run automatically during `chezmoi apply` when their tracked content changes.

| Script | Trigger | Action |
|--------|---------|--------|
| `run_onchange_01_rustup_components.sh.tmpl` | `rust/component` changed | `rustup component add` for clippy, rustfmt |
| `run_onchange_02_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` for packages not managed elsewhere |
| `run_onchange_03_claude_settings.sh.tmpl` | Claude settings pkl files changed | Regenerate `~/.config/claude/settings.json` |
| `run_onchange_04_prune-skills.sh.tmpl` | Skills under `dot_config/claude/skills/` changed | Remove deployed skills whose source entry is gone (chezmoi leaves such targets in place) |

---

## Reference

- [docs/CHEZMOI.md](docs/CHEZMOI.md) — chezmoi 操作、status シンボル
- [docs/NIX.md](docs/NIX.md) — `private_minipc` の Nix パッケージ管理と flake 構造
- [docs/HERDR.md](docs/HERDR.md) — herdr キーバインド一覧、agent state、Claude Code 連携
- [docs/TMUX.md](docs/TMUX.md) — tmux キーバインド一覧（herdr 移行期間中の参照用）
