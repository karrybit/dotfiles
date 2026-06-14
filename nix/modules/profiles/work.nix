{ lib, username, ... }:
{
  networking.hostName = "Takumis-MacBook-Pro";

  users.users.${username}.home = "/Users/${username}";

  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Batch2: work-specific k8s / backend tools
      buf
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
    ];
  };
}
