{ lib, username, ... }:
{
  # TODO: replace with actual hostname of personal MacBook Neo
  networking.hostName = "personal-neo";

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
    ];

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
      };
    };
  };

  homebrew.casks = [
    "codex"
    "google-chrome"
  ];
}
