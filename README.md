# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

- **chezmoi** manages configuration files (what goes in `~/.config/`, `~/.local/`, etc.)
- **Homebrew** manages applications (casks) on macOS, plus the formulae aqua
  cannot provide: aqua itself, chezmoi, libraries and Homebrew-path
  dependencies (openjdk, libpq, zsh-abbr), and tools missing from or built
  from source in the aqua registry
- **aqua** manages CLI and development tools on every profile
  (`dot_config/aquaproj-aqua/literal_<profile>/aqua.yaml`, checksum-verified;
  `literal_` keeps chezmoi from reading `private_neo` as the `private_` attribute)
- **uv** manages Python (`dot_config/uv/dot_python-version`) and **rustup**
  manages the Rust toolchain, since aqua does not handle those runtimes

## Directory Structure

```
~/.local/share/chezmoi/       ← source (this repository)
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
`dot_config/claude/`. See [AGENTS.md](AGENTS.md) for how agents interact with
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
4. Executes `run_onchange_` scripts (rustup, Rust components, Claude settings, skills sync)

aqua comes from Homebrew, so the aqua and Python `run_onchange_` scripts skip
on the first apply. Install it, then run what those scripts would have:

```sh
# 3. Install Homebrew, aqua-managed packages, and Python
brew bundle install --file ~/.config/homebrew/Brewfile.<profile>
exec zsh -l
aqua install --all
uv python install --default --preview-features python-install-default
```

On first launch, Neovim will automatically install plugins via lazy.nvim.

#### Linux (`private_minipc`)

No Homebrew. Install aqua with
[aqua-installer](https://aquaproj.github.io/docs/products/aqua-installer)
first, so the `run_onchange_` scripts can install the aqua-managed tools and
Python during the first apply.

```sh
# 1. Install aqua (check the installer's current version and checksum in its docs)
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.5/aqua-installer
echo "451028d56959cc738564885b1dbebc2691ea038ffde04e2472e4d486a3591146  aqua-installer" | sha256sum -c -
chmod +x aqua-installer
./aqua-installer
```

```sh
# 2. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init --apply karrybit/dotfiles
# When prompted, enter: private_minipc
```

On first launch, Neovim will automatically install plugins via lazy.nvim.

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
| `run_onchange_00_aqua.sh.tmpl` | The profile's `aquaproj-aqua/<profile>/` changed | `aqua install` for the profile's global config |
| `run_onchange_00_rustup.sh` | First apply | Install rustup into `$CARGO_HOME` and set the stable toolchain as default |
| `run_onchange_01_rustup_components.sh.tmpl` | `rust/component` changed | `rustup component add` for clippy, rustfmt |
| `run_onchange_02_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` for packages not managed elsewhere |
| `run_onchange_03_claude_settings.sh.tmpl` | Claude settings pkl files changed | Regenerate `~/.config/claude/settings.json` |
| `run_onchange_04_prune-skills.sh.tmpl` | Skills under `dot_config/claude/skills/` changed | Remove deployed skills whose source entry is gone (chezmoi leaves such targets in place) |
| `run_onchange_07_uv_python.sh.tmpl` | `uv/.python-version` changed | `uv python install` for the pinned version, linking `python`/`python3` |

---

## Reference

- [docs/CHEZMOI.md](docs/CHEZMOI.md) — chezmoi 操作、status シンボル
- [docs/NIX.md](docs/NIX.md) — Mac に残った Nix / nix-darwin をアンインストールする手順
- [docs/HERDR.md](docs/HERDR.md) — herdr キーバインド一覧、agent state、Claude Code 連携
- [docs/TMUX.md](docs/TMUX.md) — tmux キーバインド一覧（herdr 移行期間中の参照用）
