# Nix Configuration Reference

Nix (home-manager) manages all packages, and
programs that require Nix store integration (tmux plugins, nix-direnv).
Configuration lives in `nix/`. See README for rebuild commands.

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

Then rebuild (see README). To find a package name: `nix search nixpkgs <keyword>` or
[search.nixos.org](https://search.nixos.org/packages).

---

## Package management policy

| Category | Manager |
|---|---|
| CLI tools and development packages | Nix (`home.packages` in profile) |
| macOS GUI apps with self-update or system extensions | Homebrew cask (declared in `~/.config/homebrew/Brewfile.${profile}`) |
| tmux plugins, nix-direnv | Nix (`nix/modules/home/programs.nix`) |
| Rust toolchain | `rustup` (nix-managed binary; components via `run_onchange_01`) |
| Cargo packages not in nixpkgs | `cargo install` via `run_onchange_02` |
| `aqua`, `chezmoi` | Homebrew formula (permanent: nixpkgs-unlisted / bootstrap dependency) — declared in `Brewfile.${profile}` |

**Why `aqua` is installed but manages nothing here:**
aqua once managed global CLI packages. That was abolished — every tool moved to
`home.packages`, and the global configs, shell hook, and update function were
deleted from the source. The binary is kept only for work repositories that carry
their own `aqua/aqua.yaml`; those resolve through the repo config, and any command
they do not declare falls through to Nix. Do not reintroduce a global
`AQUA_GLOBAL_CONFIG` — it prepends aqua's `bin` to `PATH` and shadows Nix.

**Why macOS GUI apps stay as Homebrew casks:**
- The Nix store is read-only — apps that self-update in-place (Obsidian, DBeaver, Chrome) fail silently or crash.
- Apps requiring kernel/system extensions (Karabiner-Elements uses DriverKit) must be installed via cask; Nix cannot register system extensions.
- Apps whose nixpkgs build targets Linux only (Ghostty) cause evaluation errors on macOS.

---

## chezmoi vs Nix responsibility boundary

| Managed by | Examples |
|---|---|
| chezmoi | `~/.config/zsh/`, `~/.config/nvim/`, `~/.config/git/`, `~/.config/starship.toml`, `~/.config/herdr/config.toml` |
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

### Exception: agent-required tools

One set of tools is a contract rather than coincidence. `dot_config/claude/CLAUDE.md`
("Command-Line Tool Preferences") tells agents to prefer `rg`, `fd`, `jq`, `yq`,
and `qsv` over their POSIX equivalents. An agent runs on every machine, so a rule
naming a tool is only satisfiable if every profile declares it.

This does not move those packages into a shared module — each profile still
declares its own complete list. Only the *assertion* is shared:
`agentRequiredTools` in `nix/checks.nix` maps each binary to its nixpkgs
attribute, and `nix flake check` throws a fix-it message if any profile is
missing one. Adding a tool to the rule therefore means adding it to all three
profiles; removing it from the rule removes the obligation.

---

## Design: share-only packages (no binary)

Some nixpkgs packages install only into `share/` with no `bin/` entry
(e.g. `antidote`, shell plugin collections). With `useUserPackages = true`,
listing them in `home.packages` is not enough — the `share/` directory is
**not** merged into the user environment.

Use `home.file` to create a stable symlink to the package's whole `share/<pkg>`
directory, not to a single file inside it:

```nix
home.file.".local/share/antidote".source = "${pkgs.antidote}/share/antidote";
```

The path `~/.local/share/antidote/antidote.zsh` is then stable across rebuilds
and can be sourced directly from shell config.

Link the directory, not just the entry-point file. Some of these scripts
locate sibling files (e.g. antidote's `antidote.zsh` autoloads
`functions/antidote-setup` from a path derived from its own location) using a
symlink-preserving resolution — it deliberately does not follow a trailing
symlink to the real store path, so it expects those sibling files to sit next
to wherever it was sourced from. A file-only symlink leaves that sibling
directory missing and breaks at runtime (`function definition file not
found`); linking the whole directory keeps the sibling files alongside the
entry point.

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
    home/
      darwin.nix         # macOS home-manager base (username, homeDirectory, allowUnfree)
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
```

Rebuild manually with `home-manager switch --flake ~/.local/share/chezmoi/nix#<profile>`
(see README) — there is no task wrapper for this.

`nix flake check` runs only the current system's checks and silently omits the
other platform's. Checks that must cover every profile therefore cannot be split
per system: `--all-systems` would try to *build* the other platform's derivation
and fail with a platform mismatch. Instead register one derivation per system
that asserts across all profiles — reading a package's name is pure evaluation,
so `agent-required-tools` sees the Linux profile from a Mac. See `checks.nix`.

New files imported by the flake must be staged before `task nix:check` will
see them:

```sh
git add nix/path/to/new-file.nix
task nix:check
```
