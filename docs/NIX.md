# Uninstalling Nix from a Mac

This repository no longer uses Nix: packages come from Homebrew and aqua.
Run this procedure once on each Mac that still has Nix installed.

## 1. Check what is installed

```sh
ls /nix/nix-installer /nix/receipt.json   # Determinate Nix Installer
command -v darwin-uninstaller            # nix-darwin is active
```

If `/nix/nix-installer` or `/nix/receipt.json` is missing, Nix was installed
another way: follow the
[upstream removal instructions](https://nix.dev/manual/nix/stable/installation/uninstall.html)
instead of step 4.

## 2. Confirm nothing still depends on Nix

Apply the dotfiles and install the replacements first:

```sh
chezmoi update
exec zsh -l
aqua install --all
```

Then list the commands that exist only under Nix paths. Every name printed
is lost after the uninstall; move anything you still need to aqua or the
Brewfile before continuing.

```sh
p=$(print -rl -- ${(s.:.)PATH} | grep -viE 'nix|/run/current-system|/etc/profiles' | paste -sd: -)
for d in ~/.nix-profile/bin /etc/profiles/per-user/$USER/bin; do
  for c in $(ls "$d" 2>/dev/null); do PATH=$p whence -p "$c" >/dev/null || print "$c"; done
done | sort -u
```

## 3. Uninstall nix-darwin (only if step 1 found `darwin-uninstaller`)

nix-darwin replaces `/etc/zshrc`, `/etc/zshenv`, `/etc/zprofile`, and
`/etc/bashrc` with links into the Nix store and keeps the originals as
`*.before-nix-darwin`. Its uninstaller restores them, so it has to run while
Nix is still present:

```sh
sudo darwin-uninstaller
```

If that fails, run the latest uninstaller instead, as the
[nix-darwin README](https://github.com/nix-darwin/nix-darwin#uninstalling)
describes:

```sh
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

## 4. Uninstall Nix

The
[Determinate Nix Installer uninstaller](https://docs.determinate.systems/guides/migrating-from-upstream-nix/#uninstall-nix-if-needed)
removes the Nix store volume, the daemons, the `nixbld` users, and its shell
hooks:

```sh
sudo /nix/nix-installer uninstall
```

## 5. Remove per-user leftovers

```sh
rm -rf ~/.nix-profile ~/.nix-defexpr ~/.nix-channels ~/.local/state/nix ~/.cache/nix
```

## 6. Verify

Open a new terminal window, then:

```sh
ls /nix                               # No such file or directory
command -v nix darwin-rebuild home-manager   # prints nothing
print -l $path | grep -i nix          # prints nothing
```

Spot-check the tools you use daily, such as `tmux`, `kubectl`, and
`gke-gcloud-auth-plugin`.
