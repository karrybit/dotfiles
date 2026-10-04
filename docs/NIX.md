# Nix Configuration Reference

Nix and Home Manager are used only by the Linux `private_minipc` profile.
The macOS `work` and `private_neo` profiles use Homebrew for system tools and
mise for language runtimes and versioned development tools.

## Adding or removing Linux packages

Edit `nix/modules/profiles/private_minipc.nix`, then rebuild:

```sh
home-manager switch --flake ~/.local/share/chezmoi/nix#private_minipc
```

Find package names with `nix search nixpkgs <keyword>` or
[search.nixos.org](https://search.nixos.org/packages).

## Package management policy

| Target | Category | Manager |
|---|---|---|
| macOS | CLI tools and GUI apps | Homebrew (`Brewfile.work`, `Brewfile.private_neo`) |
| macOS | Language runtimes and versioned development tools | mise (`config.work.toml`, `config.private_neo.toml`) |
| Linux | CLI tools and development packages | Nix (`private_minipc.nix`) |
| All | Configuration files | chezmoi |
| All | Cargo packages not managed elsewhere | `cargo install` via `run_onchange_02` |

Each target profile declares its complete package set. Do not infer that a tool
installed on one machine is available on another.

## Flake structure

```text
nix/
  flake.nix
  flake.lock
  checks.nix
  lib/default.nix
  modules/
    home/
      common.nix
      linux.nix
    profiles/
      private_minipc.nix
```

## Development and testing

```sh
task check       # platform checks; Nix checks run only on Linux
task nix:check   # Linux only: flake check, statix, deadnix
task test        # render chezmoi templates and lint zsh
```

New files imported by the flake must be staged before `nix flake check` can see
them.
