defmodule Soulseek.Server.PossibleParentsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.PossibleParents
  alias Soulseek.Server.PossibleParents.Parent
  alias Soulseek.Wire

  setup do
    msg = %PossibleParents{
      parents: [
        %Parent{username: "alice", ip: 2_130_706_433, port: 2234},
        %Parent{username: "bob", ip: 3_232_235_521, port: 5000}
      ]
    }

    binary =
      IO.iodata_to_binary([
        Wire.uint32(2),
        Wire.string("alice"),
        Wire.uint32(2_130_706_433),
        Wire.uint32(2234),
        Wire.string("bob"),
        Wire.uint32(3_232_235_521),
        Wire.uint32(5000)
      ])

    %{msg: msg, binary: binary}
  end

  test "encodes the parents", %{msg: msg, binary: binary} do
    assert IO.iodata_to_binary(PossibleParents.encode(msg)) == binary
  end

  test "decodes the parents", %{msg: msg, binary: binary} do
    assert PossibleParents.decode(binary) == msg
  end

  test "round trips an empty list" do
    msg = %PossibleParents{parents: []}

    assert msg |> PossibleParents.encode() |> IO.iodata_to_binary() |> PossibleParents.decode() ==
             msg
  end
end
