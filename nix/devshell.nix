{
  mkShell,

  erlang,
  elixir,

  nixfmt,
  nixd,
}:
mkShell {
  packages = [
    erlang
    elixir

    nixfmt
    nixd
  ];
}
