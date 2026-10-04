# Removing Nix from private_minipc

Nix and Home Manager are no longer used by this repository. The Linux
`private_minipc` profile now installs its development tools from
`dot_config/mise/config.private_minipc.toml`.

## Before uninstalling

Apply the current dotfiles and confirm that mise can install the replacement
tools on `private_minipc`:

```sh
chezmoi update
MISE_CONFIG_FILE="$HOME/.config/mise/config.private_minipc.toml" ~/.local/bin/mise install
```

Open a new shell and verify the commands you use before removing Nix. The
uninstall removes the Nix store and packages installed through Home Manager.

## Uninstall

The machine was bootstrapped with Determinate Nix Installer. Its built-in
uninstaller is:

```sh
/nix/nix-installer uninstall
```

The command is documented by
[Determinate Systems](https://docs.determinate.systems/guides/migrating-from-upstream-nix/#uninstall-nix-if-needed).
If `/nix/nix-installer` or `/nix/receipt.json` does not exist, identify the
installation method and follow the
[upstream Nix removal instructions](https://nix.dev/manual/nix/stable/installation/uninstall.html)
instead.

After the uninstall, start a new shell and confirm that `nix` and
`home-manager` are no longer available while the mise-managed commands remain
available.
