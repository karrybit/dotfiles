#!/bin/zsh

function gpu_top() {
    if [[ "$OSTYPE" =~ linux* ]] && [[ -n "$(lscpu | grep 'Vendor ID:' | awk '{print $3}')" ]] && [[ -n "$(yay -Q | grep intel-gpu-tools)" ]]; then
        sudo intel_gpu_top
    fi
}

function pbcopyx() {
    if [[ "$OSTYPE" =~ linux* ]]; then
        xclip -selection c
    fi
}

function pbpastex() {
    if [[ "$OSTYPE" =~ linux* ]]; then
        xclip -selection c -o
    fi
}
