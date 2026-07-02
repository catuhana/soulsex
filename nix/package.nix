{
  lib,

  nix-gitignore,

  mixRelease,
  fetchMixDeps,

  sqlite,
}:
let
  pname = "soulsex";
  version = "0.1.0";

  src = nix-gitignore.gitignoreSource [ ] ../.;

  mixFodDeps = fetchMixDeps {
    pname = "${pname}-deps";
    inherit version src;

    hash = "sha256-65eNsH6a3LLhpWC4X1DKLat5ROfbpAJuugvPDlt+b7g=";
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

  # Make `exqlite` compile (against the system SQLite).
  env = {
    EXQLITE_USE_SYSTEM = "1";
    EXQLITE_SYSTEM_CFLAGS = "-I${sqlite.dev}/include";
    EXQLITE_SYSTEM_LDFLAGS = "-L${sqlite.out}/lib -lsqlite3";
  };

  meta = {
    description = "Soulseek server implementation in Elixir.";
    homepage = "https://github.com/catuhana/soulsex";
    license = lib.licenses.bsd3;
    sourceProvenance = lib.sourceTypes.fromSource;
    mainProgram = "soulsex";
    platforms = lib.platforms.all;
  };
}
