# Smoke-test checks for `nix flake check`.
# Each derivation forces evaluation of a key attribute; wrong types or missing
# attrs fail at evaluation time before the derivation even builds.
{ nixpkgs, darwinConfigs, homeConfigs }:
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
    work-hostname =
      mkCheck darwinPkgs "work-hostname"
        darwinConfigs.work.config.networking.hostName;

    work-state-version =
      mkCheck darwinPkgs "work-state-version"
        darwinConfigs.work.config.system.stateVersion;

    personal-neo-hostname =
      mkCheck darwinPkgs "personal-neo-hostname"
        darwinConfigs.personal_neo.config.networking.hostName;

    personal-neo-state-version =
      mkCheck darwinPkgs "personal-neo-state-version"
        darwinConfigs.personal_neo.config.system.stateVersion;
  };

  "x86_64-linux" = {
    personal-minipc-state-version =
      mkCheck linuxPkgs "personal-minipc-state-version"
        homeConfigs.personal_minipc.config.home.stateVersion;

    personal-minipc-username =
      mkCheck linuxPkgs "personal-minipc-username"
        homeConfigs.personal_minipc.config.home.username;
  };
}
