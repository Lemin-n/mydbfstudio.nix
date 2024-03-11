{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix/monthly";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";
  };
  outputs = inputs @ {
    flake-parts,
    fenix,
    nixpkgs,
    flake-utils,
    crane,
    self,
    ...
  }:
    inputs.flake-parts.lib.mkFlake
    {
      inherit inputs;
    }
    {
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        # nix develop
        devShells.default = pkgs.mkShell rec {
          shellHook = "./mydbfstudio && exit";
          packages = with pkgs; [
            libqt5pas
            xorg.libX11.dev
            xorg.libxcb
            xorg.libX11
            libsForQt5.qt5.qtwayland
          ];
          LD_LIBRARY_PATH = with pkgs; "${lib.makeLibraryPath packages}";
        };
      };
    };
}
