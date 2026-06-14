{ pkgs, username, ... }:
{
  networking.hostName = "Takumis-MacBook-Pro";

  users.users.${username}.home = "/Users/${username}";

  fonts.packages = [ pkgs.nerd-fonts.hack ];

  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      # CLI tools
      bat
      curlie
      delta
      deno
      dust
      eza
      fd
      fzf
      ghq
      gping
      hyperfine
      jq
      lazygit
      neovim
      ripgrep
      shellcheck
      tree-sitter
      yq-go

      # Dev tools
      actionlint
      awscli2
      gh
      go
      go-task
      nickel
      pkl
      terraform
      tflint

      # CLI tools (misc)
      jwt-cli
      qsv
      tfsec
      volta

      # Shell / env tools
      act
      delve
      gradle_9
      starship
      uv
      zsh-abbr

      # GUI apps (migrated from homebrew cask)
      google-cloud-sdk

      # System tools (migrated from homebrew)
      autoconf
      cmake
      git
      gnused
      libpq
      openjdk
      python313
      tree
      wget

      # k8s / backend (work)
      buf
      dbmate
      gofumpt
      kind
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      k6
      skaffold

      # Work tools
      runn
      tbls

      # Work dev tools
      air
      cargo-make
      go-migrate
      mockgen
      protobuf
      sccache
      wasm-pack

      # Rust toolchain + cargo tools (work)
      rustup
      cargo-binstall
      cargo-cache
      cargo-edit
      cargo-expand
      cargo-modules
      cargo-sort
      cargo-update
      cargo-workspaces
      sea-orm-cli
    ];

    home.file.".local/share/antidote/antidote.zsh".source =
      "${pkgs.antidote}/share/antidote/antidote.zsh";

    programs = {
      git = {
        enable = true;
        ignores = [
          ".DS_Store" ".AppleDouble" ".LSOverride" "Icon" "._*"
          ".DocumentRevisions-V100" ".fseventsd" ".Spotlight-V100"
          ".TemporaryItems" ".Trashes" ".VolumeIcon.icns"
          ".com.apple.timemachine.donotpresent"
          ".AppleDB" ".AppleDesktop" "Network Trash Folder"
          "Temporary Items" ".apdisk"
          ".idea" ".vscode" ".tours"
          "**/.claude/settings.local.json"
          "**/.config/claude/settings.json"
          "**/.config/claude/settings.work.pkl"
        ];
        settings = {
          user.name          = "karrybit";
          user.email         = "karrybit@users.noreply.github.com";
          commit.template    = "~/.stCommitMsg";
          fetch.prune        = true;
          pull.rebase        = false;
          push.default       = "current";
          ghq.root           = "~/work/ghq";
          init.defaultBranch = "main";
          credential.helper  = "osxkeychain";
          alias = {
            br  = "branch";
            fc  = "fetch --prune";
            pl  = "pull";
            df  = "diff";
            dfs = "diff --name-status";
            a   = "add";
            cm  = "commit -m";
            cme = "commit --allow-empty-message -m ''";
            ps  = "push";
            st  = "status --short";
          };
          secrets = {
            providers = "git secrets --aws-provider";
            patterns = [
              "(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}"
              ''(\"|')?(AWS|aws|Aws)?_?(SECRET|secret|Secret)?_?(ACCESS|access|Access)?_?(KEY|key|Key)(\"|')?\\s*(:|=>|=)\\s*(\"|')?[A-Za-z0-9/\\+=]{40}(\"|')?''
              ''(\"|')?(AWS|aws|Aws)?_?(ACCOUNT|account|Account)_?(ID|id|Id)?(\"|')?\\s*(:|=>|=)\\s*(\"|')?[0-9]{4}\\-?[0-9]{4}\\-?[0-9]{4}(\"|')?''
            ];
            allowed = [
              "AKIAIOSFODNN7EXAMPLE"
              "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
            ];
          };
        };
      };

      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          plus-style   = "syntax #012800";
          minus-style  = "syntax #340001";
          syntax-theme = "Monokai Extended";
          navigate     = true;
          line-numbers = true;
          side-by-side = true;
        };
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      tmux = {
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

      starship = {
        enable = true;
        settings = {
          format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
          directory = {
            style = "blue";
            truncation_length = 8;
            truncate_to_repo = false;
          };
          character = {
            success_symbol = "[❯](purple)";
            error_symbol   = "[❯](red)";
            vimcmd_symbol  = "[❮](green)";
          };
          git_branch = {
            format = "[$branch]($style)";
            style  = "bright-black";
          };
          git_status = {
            format     = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
            style      = "cyan";
            conflicted = "​";
            untracked  = "​";
            modified   = "​";
            staged     = "​";
            renamed    = "​";
            deleted    = "​";
            stashed    = "≡";
          };
          git_state = {
            format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
            style  = "bright-black";
          };
          cmd_duration = {
            format = "[$duration]($style) ";
            style  = "yellow";
          };
          python = {
            format   = "[$virtualenv]($style) ";
            style    = "bright-black";
            disabled = true;
          };
          direnv.disabled = false;
          status.disabled = false;
          sudo.disabled   = false;
        };
      };
    };
  };

  homebrew.brews = [];
  homebrew.casks = [
    # nixpkgs 未収録 or macOS 限定
    "1password"
    "cleanshot"
    "ghostty"              # nixpkgs は Linux 専用ビルドのみ
    "google-japanese-ime"
    "intellij-idea"
    "itsycal"
    "karabiner-elements"   # DriverKit 拡張のインストールが必要 — cask のみ
    "obsidian"             # アプリ内自動更新のため cask で管理
    # work 固有
    "dbeaver-community"    # アプリ内自動更新のため cask で管理
    "docker-desktop"
    "jetbrains-toolbox"
    "logi-options+"
    "microsoft-auto-update"
    "microsoft-teams"
  ];
}
