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

  linuxPkgs = nixpkgs.legacyPackages."x86_64-linux";
in
{
  "x86_64-linux" = {
    statix = linuxPkgs.runCommand "statix" {
      nativeBuildInputs = [ linuxPkgs.statix ];
    } ''
      statix check ${self}
      touch $out
    '';

    deadnix = linuxPkgs.runCommand "deadnix" {
      nativeBuildInputs = [ linuxPkgs.deadnix ];
    } ''
      deadnix --fail ${self}
      touch $out
    '';

    personal-minipc-state-version =
      mkCheck linuxPkgs "personal-minipc-state-version"
        homeConfigs.private_minipc.config.home.stateVersion;

    personal-minipc-username =
      mkCheck linuxPkgs "personal-minipc-username"
        homeConfigs.private_minipc.config.home.username;
  };
}
