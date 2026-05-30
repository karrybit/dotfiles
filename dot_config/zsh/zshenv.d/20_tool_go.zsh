mkdir -p "$XDG_DATA_HOME/go"

export GOPATH=$XDG_DATA_HOME/go
export GOPRIVATE=github.com/karrybit

path=("$GOPATH/bin" $path)
