{
  description = "karrybit's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      myLib = import ./lib inputs;

      macosHosts = {
        work = {
          system = "aarch64-darwin";
          username = "takumikaribe";
        };
        private_neo = {
          system = "aarch64-darwin";
          username = "takumikaribe";
        };
      };

      linuxHosts = {
        private_minipc = {
          system = "x86_64-linux";
          username = "takumikaribe";
        };
      };

      homeConfigurations =
        (nixpkgs.lib.mapAttrs (name: cfg:
          myLib.mkHome (cfg // {
            extraModules = [
              ./modules/home/darwin.nix
              ./modules/profiles/${name}.nix
            ];
          })
        ) macosHosts)
        //
        (nixpkgs.lib.mapAttrs (name: cfg:
          myLib.mkHome (cfg // {
            extraModules = [
              ./modules/home/linux.nix
              ./modules/profiles/${name}.nix
            ];
          })
        ) linuxHosts);

      checks = import ./checks.nix {
        inherit nixpkgs self;
        homeConfigs = homeConfigurations;
      };
    in
    {
      inherit homeConfigurations checks;
    };
}
