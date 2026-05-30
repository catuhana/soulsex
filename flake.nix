{
  description = "Soulseek server implementation in Elixir.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];

      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { lib, pkgs, ... }:
        let
          beamPackages = pkgs.beam28Packages;

          inherit (beamPackages)
            erlang
            ;

          elixir = beamPackages.elixir_1_19;
        in
        {
          packages = {
            default = pkgs.callPackage ./nix/package.nix {
              mixRelease = beamPackages.mixRelease.override { inherit elixir; };
              fetchMixDeps = beamPackages.fetchMixDeps.override { inherit elixir; };
            };
          };

          devShells.default = pkgs.mkShell {
            packages = [
              erlang
              elixir

              pkgs.nixfmt
              pkgs.nixd
            ];
          };

          treefmt = {
            programs = {
              mix-format = {
                enable = true;
                package = elixir;
              };

              nixfmt.enable = true;
            };
          };
        };
    };
}
