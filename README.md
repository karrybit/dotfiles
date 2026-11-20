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
  `literal_` keeps chezmoi from reading `private_neo` as the `private_` attribute).
  A tool missing from the standard registry goes in the profile's
  `registry.yaml` and is allowed by name in its `aqua-policy.yaml`, which
  `AQUA_POLICY_CONFIG` loads. brew clears the environment before running
  aqua's npm for `brew bundle dump`, so aqua's settings file
  (`dot_config/aquaproj-aqua/config.yaml.tmpl`) and `dot_npmrc` repeat
  these paths and `NPM_CONFIG_PREFIX`, keeping npm's global packages in the
  Brewfile
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
~/.local/share/agents/docs/   ← agent source summaries and reference files
~/.local/share/agents/scripts/ ← reusable agent-operated scripts
~/.config/karo/config.yaml    ← settings the karo plugin's scripts read ($KARO_CONFIG_HOME)
```

`chezmoi apply` deploys source → live. The `dot_` prefix is converted to `.` (e.g. `dot_config/` → `~/.config/`).

Agent instructions and settings are managed under `dot_config/claude/`.
Skills and subagents come from the `kstack` and `karo` plugins of the
`karrybit` plugin marketplace (`karrybit/plugin-marketplace`), declared in
`dot_config/claude/settings.base.pkl`. See [AGENTS.md](AGENTS.md) for how agents interact with
this repository.

Codex's `~/.codex/config.toml` is partially managed by
`dot_codex/modify_private_config.toml`. Chezmoi enforces the public user
preferences declared there while passing machine-local state such as
`[projects]` through unchanged. Its absolute paths and values therefore never
enter this repository. The `private_` source attribute keeps the live file at
mode `0600`.

Claude Code's `~/.config/claude/.claude.json` is partially managed the same
way by `dot_config/claude/modify_private_dot_claude.json`, which declares only
the user-scope `chrome-devtools` MCP server and passes the rest of that runtime
state file through with `jq`. The server's URL guard is described in
`dot_local/share/agents/scripts/chrome-devtools-url-guard/README.md`.

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

`chezmoi init --apply` automatically, in this order:

- Clones this repository to `~/.local/share/chezmoi/`
- Prompts for machine profile: enter `work` or `private_neo`
- Runs `chezmoi apply` to deploy live files
- Executes `run_onchange_` scripts (rustup and cargo packages except on `private_neo`, Claude settings, skills sync)

aqua comes from Homebrew, so the aqua and Python `run_onchange_` scripts skip
on the first apply. Install it, then run what those scripts would have. The
second `chezmoi apply` writes the files rendered from installed casks
(terminal-browser's `setup-version`):

```sh
# 3. Install Homebrew, aqua-managed packages, and Python
brew bundle install --file ~/.config/homebrew/Brewfile.<profile>
chezmoi apply
exec zsh -l
aqua install --all
uv python install --default --preview-features python-install-default
```

On first launch, Neovim will automatically install plugins via lazy.nvim.

#### Linux (`private_minipc`)

No Homebrew. Install the apt packages and aqua with
[aqua-installer](https://aquaproj.github.io/docs/products/aqua-installer)
first, so the `run_onchange_` scripts can install the aqua-managed tools and
Python during the first apply. `build-essential` provides the C linker that
`cargo install` needs, and `bubblewrap` and `socat` are what the Claude Code
sandbox requires on Linux.

```sh
# 0. Install the apt prerequisites and make zsh the login shell
sudo apt update
sudo apt install -y zsh git curl build-essential bubblewrap socat
chsh -s "$(command -v zsh)"
```

```sh
# 1. Install aqua (check the installer's current version and checksum in its docs)
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.5/aqua-installer
echo "451028d56959cc738564885b1dbebc2691ea038ffde04e2472e4d486a3591146  aqua-installer" | sha256sum -c -
chmod +x aqua-installer
./aqua-installer
```

```sh
# 2. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"
chezmoi init --apply karrybit/dotfiles
# When prompted, enter: private_minipc
```

```sh
# 3. Log in with zsh, install Claude Code, and authenticate GitHub
exec zsh -l
curl -fsSL https://claude.ai/install.sh | bash
gh auth login   # decline its Git credential setup
chezmoi apply   # now that gh is on PATH, adds gh as the GitHub credential helper
```

The Git config adds gh as the credential helper for `github.com` and
`gist.github.com` when `gh` is on PATH at apply time, so `gh auth setup-git`
is not needed; it would rewrite the helper and leave a difference that makes
`upup` stop. The helper calls the gh binary that `aqua which gh` resolves at
apply time, by absolute path, because tools such as Homebrew run Git with a
PATH that lacks aqua and its proxy. When that path changes, as with an aqua
version bump, the next `chezmoi apply` writes the new one.

Claude Code comes from its native installer, as on macOS, and Codex from aqua,
as on `private_neo`.

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

When a package update fails, `upup` still runs the remaining updates, prints a
warning, and exits non-zero without pushing or running `chezmoi apply`. Commits
made by the updates that succeeded stay local until the next successful `upup`.

`upup` and `vacuum` pass `gh auth token` to each `brew` call as
`HOMEBREW_GITHUB_API_TOKEN`, so formulae from private GitHub taps can fetch
their git sources. Without `gh` or a login, `brew` runs without a token.

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

### File browser (fb)

```bash
fb [dir]   # browse dir (default: the current directory) one level at a time
```

`fb` lists one directory at a time in fzf, including dotfiles but not `.git`.
Folders come before files; within each, names starting with `YYYY-MM-DD` come
first, newest creation time first (modification time where the filesystem does
not record creation), and the rest follow in name order. Selecting a
folder enters it and `../` goes back to the parent; `../` is not shown in the
starting directory, so browsing stays inside it. Selecting a file opens it in a
pager in the same terminal — Markdown with `glow -p`, everything else with
`bat --paging=always` — and quitting the pager (`q`) returns to the listing.
Inside a Herdr pane, the pane is named `<its name> - <path from the starting
directory>` while the file is open and gets its name back when the pager quits.
`Right` does the same as `Enter`, and `Left` goes to the parent (nothing in the
starting directory), so the arrow keys do not move the cursor in the query.
The preview, below the listing at the pane's full width, shows the hovered
file (glow for Markdown, bat otherwise) or the folder's contents. Mouse clicks
and the wheel select entries; `Esc` or `Ctrl-C` quits.

### terminal-browser

terminal-browser (`work` profile, the Homebrew cask in `Brewfile.work`) draws
a browser in a Herdr pane. It comes from Homebrew, not aqua, because the copy
aqua unpacks fails macOS's code signature check and macOS refuses to open it.
The karo plugin's `karo-crit-open` and `karo-view-open` open it through the
`tb-view` in its `scripts/`, which names the new pane `view - <name>` when
terminal-browser is its foreground process. `karo-crit-open` reloads the tab
instead when one already
shows the review's `http://localhost:<port>`, and otherwise points a tab
showing a crit review at the new URL when crit no longer answers on that tab's
port, so a review reopened on a new port keeps its tab and each running review
keeps its own;
closing the pane ends its browser, and the daemon exits 15 seconds after the
last one. Chezmoi keeps three of its files:

| File | Content |
|------|---------|
| `~/.config/terminal-browser/settings.json` | Update checks and usage and crash telemetry off. Written only when missing (`create_`), so `terminal-browser config set` changes stay |
| `~/.local/state/terminal-browser/skills-choice` | `no`: no agent skill links |
| `~/.local/state/terminal-browser/setup-version` | `<version> <install root>`, rendered from the installed cask's folder under `/opt/homebrew/Caskroom/terminal-browser/`, and not written until the cask is installed. While it matches the running install, terminal-browser skips its first-run setup, which links agent skills and edits editor settings |

The version is raised by `brew upgrade` in `upup`, like every cask;
`terminal-browser upgrade` only prints that command for a Homebrew install.
`upup` runs `chezmoi apply` after the upgrade, which rewrites `setup-version`
for the new version. After a `brew upgrade` outside `upup`, run `chezmoi apply`
before opening a terminal-browser pane; a pane opened in between runs the
first-run setup once.

terminal-browser names its state, data, cache, and profile folders
`terminal-browser-<hash>` after a hash of the install root with the Caskroom
version removed, so the folders stay across versions. A folder made by another
install root is left over: `cat ~/.local/share/terminal-browser-*/install`
prints each folder's root, and for a root other than the cask's, close every
terminal-browser pane and remove `~/.local/share/terminal-browser-<hash>`,
`~/.local/state/terminal-browser-<hash>`, `~/.cache/terminal-browser-<hash>`,
and `~/Library/Application Support/terminal-browser-<hash>`.

`brew uninstall --zap --cask terminal-browser` also removes the agent skill
links and the `~/.local/share`, `~/.cache`, and `~/.local/state` folders,
including the two chezmoi-kept files above, which the next `chezmoi apply`
writes again. It leaves `~/.config/terminal-browser` and
`~/Library/Application Support/terminal-browser-<hash>`.

### run_onchange scripts

These run automatically during `chezmoi apply` when their tracked content changes.

| Script | Trigger | Action |
|--------|---------|--------|
| `run_onchange_00_aqua.sh.tmpl` | The profile's `aquaproj-aqua/<profile>/` changed | `aqua install` for the profile's global config |
| `run_onchange_00_rustup.sh` | First apply | Install rustup into `$CARGO_HOME` and set the stable toolchain as default (its default profile includes clippy and rustfmt) |
| `run_onchange_02_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` for packages not managed elsewhere |
| `run_onchange_03_claude_settings.sh.tmpl` | Claude settings pkl files changed | Regenerate `~/.config/claude/settings.json` |
| `run_onchange_04_prune-skills.sh.tmpl` | Skills directly under `dot_config/claude/skills/` changed | Remove skills deployed directly under `~/.config/claude/skills/` whose source entry is gone (chezmoi leaves such targets in place) |
| `run_onchange_07_uv_python.sh.tmpl` | `uv/.python-version` changed | `uv python install` for the pinned version, linking `python`/`python3` |
---

## Reference

- [docs/CHEZMOI.md](docs/CHEZMOI.md) — chezmoi 操作、status シンボル
- [docs/HERDR.md](docs/HERDR.md) — herdr キーバインド一覧、agent state、Claude Code 連携
- [docs/TMUX.md](docs/TMUX.md) — tmux キーバインド一覧（herdr 移行期間中の参照用）
- [docs/WRITING.md](docs/WRITING.md) — 文書作成の Skill 運用（場面ごとの Skill の使い分けと動作確認）
