# Smoke-test checks for `nix flake check`.
# Each derivation forces evaluation of a key attribute; wrong types or missing
# attrs fail at evaluation time before the derivation even builds.
{ nixpkgs, self, homeConfigs }:
let
  # Force evaluation of `value` (must coerce to string) and write it to $out.
  mkCheck = pkgs: name: value:
    pkgs.runCommand "check-${name}" { } ''
      printf '%s\n' ${pkgs.lib.escapeShellArg (toString value)} > $out
    '';

  darwinPkgs = nixpkgs.legacyPackages."aarch64-darwin";
  linuxPkgs  = nixpkgs.legacyPackages."x86_64-linux";
in
{
  "aarch64-darwin" = {
    statix = darwinPkgs.runCommand "statix" {
      nativeBuildInputs = [ darwinPkgs.statix ];
    } ''
      statix check ${self}
      touch $out
    '';

    deadnix = darwinPkgs.runCommand "deadnix" {
      nativeBuildInputs = [ darwinPkgs.deadnix ];
    } ''
      deadnix --fail ${self}
      touch $out
    '';

    work-state-version =
      mkCheck darwinPkgs "work-state-version"
        homeConfigs.work.config.home.stateVersion;

    work-username =
      mkCheck darwinPkgs "work-username"
        homeConfigs.work.config.home.username;

    personal-neo-state-version =
      mkCheck darwinPkgs "personal-neo-state-version"
        homeConfigs.private_neo.config.home.stateVersion;

    personal-neo-username =
      mkCheck darwinPkgs "personal-neo-username"
        homeConfigs.private_neo.config.home.username;
  };

  "x86_64-linux" = {
    personal-minipc-state-version =
      mkCheck linuxPkgs "personal-minipc-state-version"
        homeConfigs.private_minipc.config.home.stateVersion;

    personal-minipc-username =
      mkCheck linuxPkgs "personal-minipc-username"
        homeConfigs.private_minipc.config.home.username;
  };
}
