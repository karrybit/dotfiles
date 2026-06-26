__lib_chezmoi_profile() {
    __lib_require_commands chezmoi jq || return 1

    local _profile
    _profile=$(chezmoi data --format json | jq -r '.profile // empty')
    if [[ -z "${_profile}" && -n "$1" ]]; then
        _profile=$1
    fi
    printf '%s' "${_profile}"
}

__lib_chezmoi_commit_file() {
    local _live_path=$1
    local _source_rel_path=$2
    local _message=$3
    local _source_path

    __lib_require_commands chezmoi git || return 1

    _source_path=$(chezmoi source-path) || return 1

    chezmoi re-add "${_live_path}" || return 1
    git -C "${_source_path}" add "${_source_rel_path}" || return 1
    if git -C "${_source_path}" diff --cached --quiet -- "${_source_rel_path}"; then
        return 0
    else
        local _status=$?
        case ${_status} in
            1) git -C "${_source_path}" commit -m "${_message}" ;;
            *) return ${_status} ;;
        esac
    fi
}
