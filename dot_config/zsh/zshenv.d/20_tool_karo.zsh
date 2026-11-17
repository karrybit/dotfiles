# Compatibility while the record repository moves from ~/cos to ~/karo; remove this file once ~/karo is in use.
# Without ~/karo, the karo plugin reads the ~/cos folders; with it, the plugin's own defaults apply, also
# over values inherited from a shell started before the move.
if [[ -e $HOME/karo ]]; then
  unset KARO_HOME KARO_DATA_HOME KARO_STATE_HOME
else
  export KARO_HOME=$HOME/cos
  export KARO_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cos
  export KARO_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}/cos
fi
