# PATH priority: aqua > uv Python > Homebrew > XDG_BIN_HOME > system
# aqua goes first so its pinned tool versions (project aqua.yaml, then the
# profile's global config) win over whatever is installed by the platform
# package manager. uv's Python links go next so the pinned Python wins too.
#
# A function because shell integrations (VS Code etc.) prepend to PATH after
# zshenv has run; .zshrc calls it again to restore this order. The list lives
# only here, so the two call sites cannot drift apart.
# typeset needs -g: without it `path` would become local to the function.
__path_priority() {
  path=(
    $XDG_DATA_HOME/aquaproj-aqua/bin
    $XDG_DATA_HOME/uv/bin
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
