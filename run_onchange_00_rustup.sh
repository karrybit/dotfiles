#!/bin/bash
set -e

export CARGO_HOME="${CARGO_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/rustup}"

if [ ! -x "$CARGO_HOME/bin/rustup" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
    sh -s -- -y --no-modify-path --default-toolchain stable
fi

if ! "$CARGO_HOME/bin/rustup" default >/dev/null 2>&1; then
  "$CARGO_HOME/bin/rustup" default stable
fi
