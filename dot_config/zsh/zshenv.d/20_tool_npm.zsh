mkdir -p "$XDG_CONFIG_HOME/npm"
mkdir -p "$XDG_CACHE_HOME/node-gyp"

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NODE_GYP_CACHE=$XDG_CACHE_HOME/node-gyp
export NODE_REPL_HISTORY=$XDG_DATA_HOME/node_repl_history
