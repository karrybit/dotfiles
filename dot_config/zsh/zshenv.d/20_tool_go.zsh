mkdir -p "$XDG_DATA_HOME/go"
mkdir -p "$XDG_CACHE_HOME/go/mod"
mkdir -p "$XDG_CACHE_HOME/go-build"
mkdir -p "$XDG_CONFIG_HOME/go"

export GOPATH=$XDG_DATA_HOME/go
export GOMODCACHE=$XDG_CACHE_HOME/go/mod
export GOCACHE=$XDG_CACHE_HOME/go-build
export GOENV=$XDG_CONFIG_HOME/go/env
export GOPRIVATE=github.com/karrybit

path=("$GOPATH/bin" $path)
