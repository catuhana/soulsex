{
  mkShell,

  erlang,
  elixir,

  nixfmt,
  nixd,
}:
let
  shell = mkShell {
    packages = [
      erlang
      elixir

      nixfmt
      nixd
    ];
  };
in
shell
