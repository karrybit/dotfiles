# PATH priority: aqua > mise > platform package manager > XDG_BIN_HOME > system
# aqua goes first so project-pinned tool versions (aqua.yaml) win over
# whatever is installed by the platform package manager. mise goes next so its
# explicitly pinned global tool versions win too.
#
# A function because shell integrations (VS Code etc.) prepend to PATH after
# zshenv has run; .zshrc calls it again to restore this order. The list lives
# only here, so the two call sites cannot drift apart.
# typeset needs -g: without it `path` would become local to the function.
__path_priority() {
  local -a managed_paths=(
    $XDG_DATA_HOME/aquaproj-aqua/bin
    $XDG_DATA_HOME/mise/shims
  )
  if [[ "$OSTYPE" == linux* ]]; then
    managed_paths+=(
      $HOME/.nix-profile/bin
      /etc/profiles/per-user/$USER/bin
      /run/current-system/sw/bin
      /nix/var/nix/profiles/default/bin
    )
  fi
  path=(
    $managed_paths
    /opt/homebrew/bin
    /opt/homebrew/sbin
    $XDG_BIN_HOME
    /usr/local/sbin
    $path
  )
  typeset -gU path
  export PATH
}
__path_priority
