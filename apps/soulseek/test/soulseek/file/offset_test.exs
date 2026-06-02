defmodule Soulseek.File.OffsetTest do
  use ExUnit.Case, async: true

  alias Soulseek.File.Offset
  alias Soulseek.Wire

  test "encodes the offset" do
    assert IO.iodata_to_binary(Offset.encode(%Offset{offset: 2_048})) ==
             IO.iodata_to_binary(Wire.uint64(2_048))
  end

  test "decodes the offset" do
    assert Offset.decode(IO.iodata_to_binary(Wire.uint64(2_048))) == %Offset{offset: 2_048}
  end

  test "round trips" do
    msg = %Offset{offset: 5_000_000_000}

    assert msg |> Offset.encode() |> IO.iodata_to_binary() |> Offset.decode() == msg
  end
end
