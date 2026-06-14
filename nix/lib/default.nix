{ nixpkgs, nix-darwin, home-manager, determinate, ... }:
{
  mkDarwin =
    { system
    , username
    , extraModules ? [ ]
    }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit username; };
      modules = [
        determinate.darwinModules.default
        home-manager.darwinModules.home-manager
        ../modules/darwin/common.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit username; };
            users.${username}.imports = [
              ../modules/home/common.nix
              ../modules/home/programs.nix
            ];
          };
        }
      ] ++ extraModules;
    };

  mkHome =
    { system
    , username
    , extraModules ? [ ]
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit username; };
      modules = [
        ../modules/home/common.nix
        ../modules/home/linux.nix
        ../modules/home/programs.nix
      ] ++ extraModules;
    };
}
