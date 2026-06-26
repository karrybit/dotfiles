{ nixpkgs, home-manager, ... }:
{
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
        ../modules/home/programs.nix
      ] ++ extraModules;
    };
}
