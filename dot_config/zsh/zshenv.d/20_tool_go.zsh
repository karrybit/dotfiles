mkdir -p "$XDG_DATA_HOME/go"
mkdir -p "$XDG_CACHE_HOME/go/mod"
mkdir -p "$XDG_CACHE_HOME/go-build"
mkdir -p "$XDG_CACHE_HOME/gopls"
mkdir -p "$XDG_CONFIG_HOME/go"

export GOPATH=$XDG_DATA_HOME/go
export GOMODCACHE=$XDG_CACHE_HOME/go/mod
export GOCACHE=$XDG_CACHE_HOME/go-build
export GOENV=$XDG_CONFIG_HOME/go/env
export GOPRIVATE=github.com/karrybit
# gopls reads this before falling back to os.UserCacheDir(), which on macOS
# resolves to ~/Library/Caches regardless of XDG_CACHE_HOME.
export GOPLSCACHE=$XDG_CACHE_HOME/gopls

path=("$GOPATH/bin" $path)
