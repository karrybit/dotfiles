# Only when kache is installed: cargo fails if RUSTC_WRAPPER names a missing command.
if command -v kache >/dev/null 2>&1; then
    export RUSTC_WRAPPER=kache
    # kache reads a single config file, and a .kache.toml in a repository would
    # otherwise replace this one, together with its local_only setting.
    export KACHE_CONFIG=$XDG_CONFIG_HOME/kache/config.toml
fi
