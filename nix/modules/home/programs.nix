{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-t";
    terminal = "tmux-256color";
    escapeTime = 10;
    historyLimit = 50000;
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    focusEvents = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      sidebar
      open
      { plugin = prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode 'on'
          set -g @prefix_highlight_show_sync_mode 'on'
        '';
      }
      nord
    ];
    extraConfig = ''
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g pane-base-index 1
      set -g renumber-windows on
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
