defmodule Soulseek.Server.RemoveThingIHateTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RemoveThingIHate
  alias Soulseek.Wire

  test "encodes the item" do
    assert IO.iodata_to_binary(RemoveThingIHate.encode(%RemoveThingIHate{item: "noise"})) ==
             IO.iodata_to_binary(Wire.string("noise"))
  end

  test "decodes the item" do
    assert RemoveThingIHate.decode(IO.iodata_to_binary(Wire.string("noise"))) ==
             %RemoveThingIHate{item: "noise"}
  end

  test "round trips" do
    msg = %RemoveThingIHate{item: "static"}

    assert msg
           |> RemoveThingIHate.encode()
           |> IO.iodata_to_binary()
           |> RemoveThingIHate.decode() == msg
  end
end
