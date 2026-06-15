# Nix Configuration Reference

Nix (nix-darwin + home-manager) manages all packages, Homebrew casks, and
programs that require Nix store integration (tmux plugins, nix-direnv).
Configuration lives in `nix/`. Use `nixr` (defined in `dot_config/zsh/functions/nixr`)
to rebuild; see README for the command reference.

---

## Adding or removing packages

Edit the profile for the target machine:

```
nix/modules/profiles/work.nix
nix/modules/profiles/private_neo.nix
nix/modules/profiles/private_minipc.nix
```

Add the package name to `home.packages`:

```nix
home.packages = with pkgs; [
  # ...existing packages...
  ripgrep  # ← add here
];
```

Then rebuild with `nixr` (see README). To find a package name: `nix search nixpkgs <keyword>` or
[search.nixos.org](https://search.nixos.org/packages).

---

## Package management policy

| Category | Manager |
|---|---|
| CLI tools and development packages | Nix (`home.packages` in profile) |
| macOS GUI apps with self-update or system extensions | Homebrew cask (declared in profile's `homebrew.casks`) |
| tmux plugins, nix-direnv | Nix (`nix/modules/home/programs.nix`) |
| Rust toolchain | `rustup` (nix-managed binary; components via `run_onchange_01`) |
| Cargo packages not in nixpkgs | `cargo install` via `run_onchange_02` |
| `aqua`, `chezmoi` | Homebrew formula (permanent: nixpkgs-unlisted / bootstrap dependency) |

**Why macOS GUI apps stay as Homebrew casks:**
- The Nix store is read-only — apps that self-update in-place (Obsidian, DBeaver, Chrome) fail silently or crash.
- Apps requiring kernel/system extensions (Karabiner-Elements uses DriverKit) must be installed via cask; Nix cannot register system extensions.
- Apps whose nixpkgs build targets Linux only (Ghostty) cause evaluation errors on macOS.

---

## chezmoi vs Nix responsibility boundary

| Managed by | Examples |
|---|---|
| chezmoi | `~/.config/zsh/`, `~/.config/nvim/`, `~/.config/git/`, `~/.config/starship.toml` |
| Nix — profile | CLI packages, Homebrew casks |
| Nix — `home/programs.nix` | `programs.tmux` (plugins), `programs.direnv` (nix-direnv) |

Shell configuration files (`.zshrc`, `.zshenv`, functions, widgets), git
config, and starship config are chezmoi-managed. Tmux plugins and direnv's nix
integration (`nix-direnv.enable`) must stay in Nix because they depend on the
Nix store. Shell init hooks (`eval "$(direnv hook zsh)"`,
`eval "$(starship init zsh)"`) call nix-managed binaries and do not need to
move into Nix.

---

## Design: profile-per-package principle

Each profile declares its own **complete** package list independently.
Do **not** move packages into shared modules to reduce duplication.

Two profiles sharing a tool is coincidence, not a contract. Putting shared
packages into `common.nix` would:
- impose a false declaration that every environment needs that tool
- require touching multiple files to add or remove from one profile
- make natural divergence between profiles look like something to fix

`home/common.nix` exists only for home-manager framework settings
(`home.stateVersion`, `programs.home-manager.enable`). It must not contain
packages.

---

## Design: share-only packages (no binary)

Some nixpkgs packages install only into `share/` with no `bin/` entry
(e.g. `antidote`, shell plugin collections). With `useUserPackages = true`,
listing them in `home.packages` is not enough — the `share/` directory is
**not** merged into the user environment.

Use `home.file` to create a stable symlink directly to the Nix store path:

```nix
home.file.".local/share/antidote/antidote.zsh".source =
  "${pkgs.antidote}/share/antidote/antidote.zsh";
```

The path `~/.local/share/antidote/antidote.zsh` is then stable across rebuilds
and can be sourced directly from shell config.

---

## Flake structure

```
nix/
  flake.nix              # inputs, outputs, host definitions
  flake.lock             # pinned input revisions
  checks.nix             # nix flake check derivations (statix, deadnix, zsh lint)
  lib/
    default.nix          # mkDarwin / mkHome helpers
  modules/
    darwin/
      common.nix         # nix-darwin base (determinateNix, nixpkgs, system settings)
      homebrew.nix       # Homebrew setup (taps, permanent brews, cleanup policy)
    home/
      common.nix         # home-manager framework settings (stateVersion)
      linux.nix          # Linux-only home-manager settings
      programs.nix       # shared programs: tmux (plugins), direnv (nix-direnv)
    profiles/
      work.nix           # work MacBook packages + casks
      private_neo.nix   # personal MacBook packages + casks
      private_minipc.nix # Linux mini-PC packages
```

---

## Development and testing

```sh
task check       # all checks: nix:check + test
task nix:check   # nix flake check + statix (antipatterns) + deadnix (unused bindings)
task test        # render chezmoi templates (3 profiles) + zsh -n lint
task nix:rebuild # rebuild and activate current profile (nixr)
```

New files imported by the flake must be staged before `task nix:check` will
see them:

```sh
git add nix/path/to/new-file.nix
task nix:check
```
