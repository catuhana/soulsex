{
  lib,

  nix-gitignore,

  mixRelease,
  fetchMixDeps,
}:
let
  soulsex =
    let
      pname = "soulsex";
      version = "0.1.0";

      src = nix-gitignore.gitignoreSource [ ] ../.;

      mixFodDeps = fetchMixDeps {
        pname = "${pname}-deps";
        inherit version src;

        hash = "sha256-OsRfifiklS+7PwpjvhhZ+wHnYUiSSZwgQTe/adksDSQ=";
      };

      removeCookie = false;
    in
    mixRelease {
      inherit
        pname
        version

        src

        mixFodDeps

        removeCookie
        ;

      meta = {
        description = "Soulseek server implementation in Elixir.";
        homepage = "https://github.com/catuhana/soulsex";
        license = lib.licenses.bsd3;
        sourceProvenance = lib.sourceTypes.fromSource;
        mainProgram = "soulsex";
        platforms = lib.platforms.all;
      };
    };
in
soulsex
