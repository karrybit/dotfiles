#!/bin/zsh

source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

if type brew &>/dev/null; then
    chmod go-w '/opt/homebrew/share'
    chmod -R go-w '/opt/homebrew/share/zsh'
    FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH
    autoload -Uz compinit
    compinit
fi

abbr -S '..'='cd ..'
abbr -S '../..'='cd ../..'
abbr -S '../../..'='cd ../../..'
abbr -S '../../../..'='cd ../../../..'
abbr -S '../../../../..'='cd ../../../../..'
abbr -S l='eza -lbghHimSuU --time-style long-iso --git -s Name'
abbr -S ls='eza -lbghHimSuU --time-style long-iso --git -s Name'
abbr -S ll='eza -lbghHimSuU --time-style long-iso --git -s Name'
abbr -S la='eza -labghHimSuU --time-style long-iso --git -s Name'
abbr -S top='glances'
abbr -S du='dust -r -d 1'
abbr -S df='duf'
abbr -S ping='gping'
abbr -S curl='curlie'
abbr -S g='git'
abbr -S d='docker'
abbr -S dc='docker compose'
abbr -S k='kubectl'
abbr -S c='cargo'
abbr -S vim='nvim'
