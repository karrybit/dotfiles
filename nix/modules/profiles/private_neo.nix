{ username, ... }:
{
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

    home.file.".local/share/antidote/antidote.zsh".source =
      "${pkgs.antidote}/share/antidote/antidote.zsh";
  };

  homebrew.casks = [
    # nixpkgs 未収録 or macOS 限定
    "1password"
    "cleanshot"
    "codex"
    "ghostty"              # nixpkgs は Linux 専用ビルドのみ
    "google-japanese-ime"
    "intellij-idea"
    "itsycal"
    "karabiner-elements"   # DriverKit 拡張のインストールが必要 — cask のみ
    "google-chrome"        # 自己更新機能が nix store の読み取り専用制約で壊れる
    "obsidian"             # アプリ内自動更新のため cask で管理
  ];
}
