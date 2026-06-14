# PATH priority: Nix > Homebrew > XDG_BIN_HOME > system
# Nix paths are also set by nix-darwin via /etc/zshenv → set-environment;
# re-stated here so they precede Homebrew in non-login shells too.
path=(
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
