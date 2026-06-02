defmodule Soulseek.Server.ExcludedSearchPhrasesTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ExcludedSearchPhrases
  alias Soulseek.Wire

  setup do
    msg = %ExcludedSearchPhrases{phrases: ["badword", "anotherone"]}

    binary =
      IO.iodata_to_binary([
        Wire.uint32(2),
        Wire.string("badword"),
        Wire.string("anotherone")
      ])

    %{msg: msg, binary: binary}
  end

  test "encodes", %{msg: msg, binary: binary} do
    assert IO.iodata_to_binary(ExcludedSearchPhrases.encode(msg)) == binary
  end

  test "decodes", %{msg: msg, binary: binary} do
    assert ExcludedSearchPhrases.decode(binary) == msg
  end

  test "round trips an empty list" do
    msg = %ExcludedSearchPhrases{phrases: []}

    assert msg
           |> ExcludedSearchPhrases.encode()
           |> IO.iodata_to_binary()
           |> ExcludedSearchPhrases.decode() == msg
  end
end
