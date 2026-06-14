{
  description = "karrybit's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-community/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      myLib = import ./lib inputs;

      darwinHosts = {
        work = {
          system = "aarch64-darwin";
          username = "takumikaribe";
        };
        personal_neo = {
          system = "aarch64-darwin";
          username = "takumikaribe";
        };
      };

      linuxHosts = {
        personal_minipc = {
          system = "x86_64-linux";
          username = "takumikaribe";
        };
      };
    in
    {
      darwinConfigurations = nixpkgs.lib.mapAttrs (name: cfg:
        myLib.mkDarwin (cfg // {
          extraModules = [ ./modules/profiles/${name}.nix ];
        })
      ) darwinHosts;

      homeConfigurations = nixpkgs.lib.mapAttrs (name: cfg:
        myLib.mkHome (cfg // {
          extraModules = [ ./modules/profiles/${name}.nix ];
        })
      ) linuxHosts;
    };
}
