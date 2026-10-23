# uv links `python`/`python3` here instead of XDG_BIN_HOME, which sits behind
# Homebrew in PATH and would leave Homebrew's python3 in front.
export UV_PYTHON_BIN_DIR=$XDG_DATA_HOME/uv/bin
