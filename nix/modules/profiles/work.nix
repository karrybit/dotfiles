{ lib, username, ... }:
{
  networking.hostName = "Takumis-MacBook-Pro";

  users.users.${username}.home = "/Users/${username}";

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
      direnv
      gradle_9
      starship
      uv
      zsh-abbr

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
  };

  home-manager.users.${username} = { ... }: {
    programs.git = {
      enable = true;
      userName = "karrybit";
      userEmail = "karrybit@users.noreply.github.com";
      aliases = {
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
      delta = {
        enable = true;
        options = {
          plus-style    = "syntax #012800";
          minus-style   = "syntax #340001";
          syntax-theme  = "Monokai Extended";
          navigate      = true;
          line-numbers  = true;
          side-by-side  = true;
        };
      };
      extraConfig = {
        commit.template    = "~/.stCommitMsg";
        fetch.prune        = true;
        pull.rebase        = false;
        push.default       = "current";
        ghq.root           = "~/work/ghq";
        init.defaultBranch = "main";
        credential.helper  = "osxkeychain";
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
  };

  homebrew.brews = [];
  homebrew.casks = [
    "dbeaver-community"
    "docker-desktop"
    "font-hack-nerd-font"
    "gcloud-cli"
    "jetbrains-toolbox"
    "logi-options+"
    "microsoft-auto-update"
    "microsoft-teams"
  ];
}
