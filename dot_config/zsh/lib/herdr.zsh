__lib_herdr_server_running() {
    herdr status server --json | jq -e '.running' >/dev/null 2>&1
}

# Starts the server without attaching a client. herdr creates its default
# workspace only for a connected client, so a headless start leaves the
# workspace choice to the caller. Waits out herdr's own 15s readiness bound.
__lib_herdr_start_server() {
    nohup herdr server >/dev/null 2>&1 &!

    repeat 150; do
        __lib_herdr_server_running && return 0
        sleep 0.1
    done
    return 1
}
