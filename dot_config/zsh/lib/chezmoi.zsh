__lib_chezmoi_profile() {
    __lib_require_commands chezmoi jq mktemp || return 1

    # `jq` can hang forever waiting on stdin if a stray mise shim shadows it
    # (mise's shims/installs dirs are global, not scoped per profile config,
    # so testing a different profile's config on this machine can leave one
    # behind). Bound the wait so that surfaces as a visible warning instead
    # of silently blocking whatever called this.
    local _default=$1
    local _timeout=10
    local _outfile
    local _pid
    local _waited=0
    local _timed_out=0

    _outfile=$(mktemp) || return 1
    chezmoi data --format json 2>/dev/null | jq -r '.profile // empty' >"${_outfile}" &
    _pid=$!

    while kill -0 "${_pid}" 2>/dev/null; do
        if (( _waited >= _timeout )); then
            kill -9 "${_pid}" 2>/dev/null
            wait "${_pid}" 2>/dev/null
            _timed_out=1
            break
        fi
        sleep 1
        (( _waited++ ))
    done

    local _profile
    _profile=$(<"${_outfile}")
    rm -f "${_outfile}"

    if (( _timed_out )); then
        __lib_echo_warning "chezmoi profile lookup timed out after ${_timeout}s (chezmoi data | jq hung) — falling back to \"${_default:-unknown}\"\n"
    fi

    [[ -z "${_profile}" ]] && _profile=${_default}
    if [[ -z "${_profile}" ]]; then
        return 1
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
