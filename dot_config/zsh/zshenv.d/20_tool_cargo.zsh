mkdir -p "$XDG_DATA_HOME/cargo"

export CARGO_HOME=$XDG_DATA_HOME/cargo

path=("$CARGO_HOME/bin" $path)
