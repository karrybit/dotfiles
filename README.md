# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Directory Structure

```
~/.local/share/chezmoi/   ← source (this repository)
~/.config/                ← live (files read by each application)
```

`chezmoi apply` deploys source → live. The `dot_` prefix is converted to `.` (e.g. `dot_config/` → `~/.config/`).

---

## Usage

### Apply dotfiles to a new machine

```sh
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi and apply dotfiles
brew install chezmoi
chezmoi init --apply karrybit/dotfiles
```

`chezmoi init --apply` automatically:

1. Clones this repository to `~/.local/share/chezmoi/`
2. Prompts for machine profile: enter `work` or `personal`
3. Runs `chezmoi apply` to deploy live files
4. Executes `run_onchange_` scripts (installs Homebrew packages, aqua tools, and Rust tools)

On first launch, Neovim will automatically install plugins via lazy.nvim.

---

### Set profile on an existing machine (without re-running init)

Edit `~/.config/chezmoi/chezmoi.toml` directly:

```toml
[data]
    name = "karrybit"
    profile = "work"   # or "personal"
```

Then run `chezmoi apply`.

---

### Edit source and apply to machine

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

### Sync live changes back to source (re-add)

Use this when a tool automatically updates a live file (e.g. `brew bundle dump` rewrites the Brewfile, or `aqua update` rewrites the aqua config).

```sh
# Write live → source (profile-specific files)
chezmoi re-add ~/.config/homebrew/Brewfile.work   # or Brewfile.personal
chezmoi re-add ~/.config/aquaproj-aqua/aqua.work.yaml   # or aqua.personal.yaml

# Review and commit
chezmoi git diff
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
| `run_onchange_01_homebrew.sh.tmpl` | `Brewfile.{profile}` changed | `brew bundle install` |
| `run_onchange_02_aqua.sh.tmpl` | `aqua.{profile}.yaml` changed | `aqua install --all` |
| `run_onchange_03_rustup_components.sh.tmpl` | `rust/component` changed | `rustup component add` |
| `run_onchange_04_cargo_packages.sh.tmpl` | `rust/package` changed | `cargo install` |
