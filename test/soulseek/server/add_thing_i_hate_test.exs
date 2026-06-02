defmodule Soulseek.Server.AddThingIHateTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.AddThingIHate
  alias Soulseek.Wire

  test "encodes the item" do
    assert IO.iodata_to_binary(AddThingIHate.encode(%AddThingIHate{item: "noise"})) ==
             IO.iodata_to_binary(Wire.string("noise"))
  end

  test "decodes the item" do
    assert AddThingIHate.decode(IO.iodata_to_binary(Wire.string("noise"))) ==
             %AddThingIHate{item: "noise"}
  end

  test "round trips" do
    msg = %AddThingIHate{item: "static"}

    assert msg |> AddThingIHate.encode() |> IO.iodata_to_binary() |> AddThingIHate.decode() == msg
  end
end
