{ lib, username, ... }:
{
  networking.hostName = "Takumis-MacBook-Pro";

  users.users.${username}.home = "/Users/${username}";

  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Batch2: work-specific k8s / backend tools
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

      # Batch3: work-specific tools
      runn
      tbls

      # Phase 6 (aqua migration): work-specific tools
      air
      cargo-make
      golang-migrate
      mockgen
      protobuf
      sccache
      wasm-pack

      # Phase 5: Rust toolchain + cargo tools
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

  # Phase 4: work-specific Homebrew packages (cargo-* moved to nix)
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
