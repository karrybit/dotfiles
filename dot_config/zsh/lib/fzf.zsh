__lib_fzf_select_ghq_dir() {
    local root selected
    root=$(ghq root) || return 1
    selected=$(ghq list | fzf -x --cycle --layout=reverse --delimiter='/' --with-nth='2..')
    [[ -z "$selected" ]] && return 1
    printf '%s/%s\n' "$root" "$selected"
}

__lib_fzf_select_worktree() {
    git worktree list | fzf -x --cycle --layout=reverse
}

# Navigate into a directory tree with fzf+bat preview.
# Prints the selected path to stdout. Returns 1 if cancelled.
__lib_fzf_browse_dir() {
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

# Pick a ghq repo dir via fzf. Announces the choice on stderr and echoes the
# repo path to stdout. Returns 1 if cancelled.
__lib_fzf_pick_ghq_dir() {
    local dir
    dir=$(__lib_fzf_select_ghq_dir) || { __lib_echo_failure "canceled\n"; return 1; }
    __lib_echo_success "selected " >&2
    printf '%s\n' "$dir" >&2
    printf '%s' "$dir"
}

# Pick a ghq repo dir, then browse into a file within it. Same I/O contract as
# __lib_fzf_pick_ghq_dir: file path on stdout, messages on stderr.
__lib_fzf_pick_ghq_file() {
    local dir
    dir=$(__lib_fzf_pick_ghq_dir) || return 1
    __lib_fzf_browse_dir "$dir" || { __lib_echo_failure "canceled\n"; return 1; }
}
