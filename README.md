# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

- **chezmoi** manages configuration files (what goes in `~/.config/`, `~/.local/`, etc.)
- **Homebrew** manages applications (casks) on macOS, plus the formulae aqua
  cannot provide: aqua itself, chezmoi, libraries and Homebrew-path
  dependencies (openjdk, libpq, zsh-abbr), tools missing from or built
  from source in the aqua registry (eza on macOS, where aqua builds it with
  cargo), and gh on macOS, which the Claude desktop app runs from the home
  directory without `AQUA_GLOBAL_CONFIG`
- **Profiles**: `work` and `private_minipc` are development machines.
  `private_neo` is a thin client for terminal work (shell, git/GitHub, editing,
  Codex), so it gets no language toolchains, JDK, or IDE, and its Rust
  scripts and `.config/rust` are excluded in `.chezmoiignore` so nothing
  compiles there
  Profiles differ only in which tools they include; a given tool is installed
  the same way on every profile that has it. The platform exceptions are
  eza, which aqua can only build from source on macOS, and gh, which the
  Claude desktop app on macOS cannot reach through aqua, so macOS profiles
  use Homebrew for both and Linux uses aqua. Rust-built tools aqua has no binary for
  (`dot_config/rust/package`) are installed with `cargo install`, never via
  the Brewfile
- **aqua** manages CLI and development tools on every profile
  (`dot_config/aquaproj-aqua/literal_<profile>/aqua.yaml`, checksum-verified;
  `literal_` keeps chezmoi from reading `private_neo` as the `private_` attribute)
- **uv** manages Python (`dot_config/uv/dot_python-version`) and **rustup**
  manages the Rust toolchain (not on `private_neo`), since aqua does not
  handle those runtimes

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
4. Executes `run_onchange_` scripts (rustup and cargo packages except on `private_neo`, Claude settings, skills sync)

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
upup            # pull + apply dotfiles, update all packages, push generated commits
upup --vacuum   # the same, then run vacuum if it succeeded
vacuum          # delete tool caches and unreferenced old versions
```

`vacuum` runs one `__clean_<tool>` function per tool and continues past a
failing step. It removes:

| Tool | Removed |
|------|---------|
| Homebrew (macOS) | unused dependencies, all cached downloads and old versions |
| aqua | packages unused for `AQUA_VACUUM_DAYS` days (default 60), shims and registry versions that neither the global config nor any `aqua.yaml` under the ghq root uses, the registry cache |
| Go | build, module, test, and fuzz caches, and the gopls cache |
| Cargo | `$CARGO_HOME/registry` and `$CARGO_HOME/git` |
| uv | the whole cache |
| npm | the npm cache and the node-gyp cache |

Removed caches are downloaded again on next use, so the first build after a
vacuum is slower and needs network access.

### Branch and worktree cleanup

```sh
git-vacuum             # plan only: list what would go and what is kept, and why
git-vacuum --apply     # delete the planned branches and worktrees
git-vacuum -v <repo>   # one repository, also listing protected and in-use items
```

Without arguments it covers every ghq repository and the chezmoi source.
Branches are not caches: a deleted branch cannot be downloaded again, so
`git-vacuum` is separate from `vacuum` and only plans unless given `--apply`.

A local branch goes only when its work is already on the remote:

- its tip is contained in the origin default branch, or
- a GitHub PR from it was merged and that PR's head is the local tip. A tip
  that moved after the merge is kept, since the later commits exist nowhere else.

Everything else stays and is reported: open or closed PRs, branches without a
PR, the default branch, `main`, `master`, `develop`, `trunk`, `release/*`,
`hotfix/*`, and any glob in `GIT_VACUUM_PROTECT`.

A linked worktree is removed, together with its branch, only when it is clean,
not locked, its branch qualifies as above, and its HEAD and index have not
changed for `GIT_VACUUM_MIN_AGE_HOURS` hours (default 24), so a session that
has just started keeps its checkout. `git worktree lock` keeps any worktree.
Entries whose directory is already gone are pruned. Directories under
`.claude/worktrees` that git does not track are reported and left alone.

Every deletion is appended with its SHA to
`$XDG_STATE_HOME/git-vacuum/deleted.tsv`; restore one with
`git branch <name> <sha>`.

### run_onchange scripts

These run automatically during `chezmoi apply` when their tracked content changes.

| Script | Trigger | Action |
|--------|---------|--------|
| `run_onchange_00_aqua.sh.tmpl` | The profile's `aquaproj-aqua/<profile>/` changed | `aqua install` for the profile's global config |
| `run_onchange_00_rustup.sh` | First apply | Install rustup into `$CARGO_HOME` and set the stable toolchain as default (its default profile includes clippy and rustfmt) |
| `run_onchange_02_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` for packages not managed elsewhere |
| `run_onchange_03_claude_settings.sh.tmpl` | Claude settings pkl files changed | Regenerate `~/.config/claude/settings.json` |
| `run_onchange_04_prune-skills.sh.tmpl` | Skills under `dot_config/claude/skills/` changed | Remove deployed skills whose source entry is gone (chezmoi leaves such targets in place) |
| `run_onchange_07_uv_python.sh.tmpl` | `uv/.python-version` changed | `uv python install` for the pinned version, linking `python`/`python3` |

---

## Reference

- [docs/CHEZMOI.md](docs/CHEZMOI.md) — chezmoi 操作、status シンボル
- [docs/HERDR.md](docs/HERDR.md) — herdr キーバインド一覧、agent state、Claude Code 連携
- [docs/TMUX.md](docs/TMUX.md) — tmux キーバインド一覧（herdr 移行期間中の参照用）
- [docs/WRITING.md](docs/WRITING.md) — 文書作成の Skill 運用（場面ごとの Skill の使い分けと動作確認）
