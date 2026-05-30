#!/bin/zsh

source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

if type brew &>/dev/null; then
    chmod go-w '/opt/homebrew/share'
    chmod -R go-w '/opt/homebrew/share/zsh'
    FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH
fi

abbr -S cm='chezmoi'
abbr -S '..'='cd ..'
abbr -S '../..'='cd ../..'
abbr -S '../../..'='cd ../../..'
abbr -S '../../../..'='cd ../../../..'
abbr -S '../../../../..'='cd ../../../../..'
abbr -S l='eza -lhU --no-filesize --time-style long-iso --git -s Name'
abbr -S la='eza -lahU --no-filesize --time-style long-iso --git -s Name'
abbr -S ll='eza -lbghHimSuU --time-style long-iso --git -s Name'
abbr -S dur='dust -r -d 1'
abbr -S g='git'
abbr -S d='docker'
abbr -S dcp='docker compose'
abbr -S k='kubectl'
abbr -S c='cargo'
