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

  homebrew.brews = [];
  homebrew.casks = [
    "dbeaver-community"
    "discord"
    "docker-desktop"
    "drawio"
    "font-hack-nerd-font"
    "gcloud-cli"
    "jetbrains-toolbox"
    "logi-options+"
    "microsoft-auto-update"
    "microsoft-teams"
  ];
}
