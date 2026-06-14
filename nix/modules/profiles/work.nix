{ lib, username, ... }:
{
  networking.hostName = "Takumis-MacBook-Pro";

  users.users.${username}.home = "/Users/${username}";

  # Batch2: work-specific k8s / backend tools
  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      buf
      gofumpt
      kind
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      k6
      skaffold
    ];
  };
}
