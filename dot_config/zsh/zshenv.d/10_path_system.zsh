# PATH priority: aqua > Nix > Homebrew > XDG_BIN_HOME > system
# Nix paths are also set by nix-darwin via /etc/zshenv → set-environment;
# re-stated here so they precede Homebrew in non-login shells too.
# aqua goes first so project-pinned tool versions (aqua.yaml) win over
# whatever happens to be installed via Nix/Homebrew.
path=(
  $XDG_DATA_HOME/aquaproj-aqua/bin
  $HOME/.nix-profile/bin
  /etc/profiles/per-user/$USER/bin
  /run/current-system/sw/bin
  /nix/var/nix/profiles/default/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $XDG_BIN_HOME
  /usr/local/sbin
  $path
)
