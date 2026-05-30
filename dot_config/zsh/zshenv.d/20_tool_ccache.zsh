mkdir -p "$XDG_CACHE_HOME/ccache"

export CCACHE_CONFIGPATH=$XDG_CONFIG_HOME/ccache.config
export CCACHE_DIR=$XDG_CACHE_HOME/ccache
