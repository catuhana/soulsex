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

          inherit (beamPackages) erlang;
          elixir = beamPackages.elixir_1_20;
        in
        {
          packages =
            let
              mixRelease = beamPackages.mixRelease.override { inherit elixir; };
              fetchMixDeps = beamPackages.fetchMixDeps.override { inherit elixir; };
            in
            import ./nix/package.nix {
              inherit mixRelease fetchMixDeps;
              inherit (pkgs) nix-gitignore;
              inherit lib;
            };

          devShells = import ./nix/devshell.nix {
            inherit (pkgs) mkShell nixfmt nixd;
            inherit erlang elixir;
          };

          treefmt = import ./nix/formatter.nix { inherit elixir; };
        };
    };
}
