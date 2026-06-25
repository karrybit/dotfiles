{ pkgs, username, ... }:
{
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
      nodejs_22

      # Shell / env tools
      act
      delve
      gradle_9
      starship
      uv
      zsh-abbr

      # gcloud SDK (CLI) — extra components declared here, not via `gcloud components`
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        alpha
        beta
        cloud-sql-proxy
        gke-gcloud-auth-plugin
      ]))

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

      # GUI apps
      obsidian
    ];

    home.file.".local/share/antidote/antidote.zsh".source =
      "${pkgs.antidote}/share/antidote/antidote.zsh";
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
    # work 固有
    "dbeaver-community"    # アプリ内自動更新のため cask で管理
    "docker-desktop"
    "jetbrains-toolbox"
    "logi-options+"
    "microsoft-auto-update"
    "microsoft-teams"
  ];
}
