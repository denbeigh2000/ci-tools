{
  description = "CI tooling for Denbeigh's repositories/projects";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = import ./overlay.nix;
    in
    {
      overlays.default = overlay;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };

        inherit (pkgs.denbeigh.ci) devShell tool;
      in
      {
        apps.default = {
          type = "app";
          program = "${pkgs.denbeigh.ci.tool}/bin/ci";
        };

        devShells.default = devShell;

        packages = {
          default = tool;
          inherit tool;
        };
      }
    );
}
