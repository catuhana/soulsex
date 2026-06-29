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
          beamPackages = pkgs.beam29Packages;

          erlang = beamPackages.erlang;
          elixir = beamPackages.elixir_1_20;
        in
        {
          packages =
            let
              inherit (beamPackages)
                mixRelease
                fetchMixDeps
                ;
            in
            {
              default = pkgs.callPackage ./nix/package.nix {
                mixRelease = mixRelease.override { inherit elixir; };
                fetchMixDeps = fetchMixDeps.override { inherit elixir; };
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
