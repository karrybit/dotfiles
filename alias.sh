#!/bin/bash

alias ..='cd ..'
alias cat='bat'
alias l='exa -lbghHimSuU@ --time-style long-iso --git -s Name'
alias ls='exa -lbghHimSuU@ --time-style long-iso --git -s Name'
alias ll='exa -lbghHimSuU@ --time-style long-iso --git -s Name'
alias la='exa -labghHimSuU@ --time-style long-iso --git -s Name'
alias grep='rg'
alias find='fd'
alias vim='nvim'
alias top='glances'
alias du='dust -r -d 1'
alias df='duf'
alias tree='broot -hp'
alias sed='sd'
alias ping='gping'
alias ps='procs'
alias curl='curlie'
alias cd='z'

alias yq='yq eval -C'

# interpreter
alias gorepl='gore'
alias rustrepl='evcxr'

# kubernetes
alias k='kubectl'
alias kex='kubectl exec'
alias kg='kubectl get'
alias ked='kubectl edit'

# memo
alias mmn='memo new'
alias mme='memo edit'
