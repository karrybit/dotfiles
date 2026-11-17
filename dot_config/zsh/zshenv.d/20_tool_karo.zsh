# Folders the karo plugin's scripts, hooks, and skills read. The record
# repository and its data and state folders are under the name cos; config.yaml
# is under karo.
export KARO_HOME=$HOME/cos
export KARO_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cos
export KARO_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}/karo
export KARO_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}/cos
