#!/bin/bash
# run_onchange_: このスクリプト自身の内容が変わった時だけ再実行される
set -e

ANTIDOTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"

if [ -L "$ANTIDOTE_DIR" ]; then
  rm "$ANTIDOTE_DIR"
fi

if [ ! -d "$ANTIDOTE_DIR" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi
