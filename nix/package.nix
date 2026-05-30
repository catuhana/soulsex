{
  lib,

  nix-gitignore,
  emptyDirectory,

  mixRelease,
  fetchMixDeps,
}:
let
  pname = "soulsex";
  version = "0.1.0";

  src = nix-gitignore.gitignoreSource [ ] ../.;

  # We don't have a dependency needed on `:prod` env yet,
  # so just use an empty directory.
  mixFodDeps = emptyDirectory;
  /*
    fetchMixDeps {
      pname = "${pname}-deps";
      inherit version src;

      hash = lib.fakeHash;
    };
  */
  mixReleaseArgs = "soulsex";

  removeCookie = false;
in
mixRelease {
  inherit
    pname
    version

    src

    mixFodDeps
    mixReleaseArgs

    removeCookie
    ;

  meta = {
    description = "Soulseek server implementation in Elixir.";
    homepage = "https://github.com/catuhana/soulsex";

    licenses = lib.licenses.bsd3;
    sourceProvenance = lib.sourceTypes.fromSource;

    mainProgram = "soulsex";

    platforms = lib.platforms.all;
  };
}
