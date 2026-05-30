_fzf_select_ghq_dir() {
    local root selected
    root=$(ghq root)
    selected=$(ghq list | fzf -x --cycle --layout=reverse --delimiter='/' --with-nth='2..')
    [[ -z "$selected" ]] && return
    echo "${root}/${selected}"
}

_fzf_select_worktree() {
    git worktree list | fzf -x --cycle --layout=reverse
}

# Navigate into a directory tree with fzf+bat preview.
# Prints the selected path to stdout. Returns 1 if cancelled.
_fzf_browse_dir() {
    local dir="${1}/"
    local s
    while [[ -d "$dir" ]]; do
        s=$(/bin/ls -ap "$dir" | fzf -x --cycle --layout=reverse \
            --preview="if [ -f ${dir}{} ]; then bat --color=always --style=header,grid,numbers ${dir}{}; fi")
        [[ -z "$s" ]] && return 1
        dir="${dir}${s}"
    done
    echo "$dir"
}
