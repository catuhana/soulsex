defmodule Soulseek.Server.RoomMembersTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomMembers
  alias Soulseek.Wire

  setup do
    msg = %RoomMembers{room: "secret", members: ["alice", "bob"]}

    binary =
      IO.iodata_to_binary([
        Wire.string("secret"),
        Wire.uint32(2),
        Wire.string("alice"),
        Wire.string("bob")
      ])

    %{msg: msg, binary: binary}
  end

  test "encodes", %{msg: msg, binary: binary} do
    assert IO.iodata_to_binary(RoomMembers.encode(msg)) == binary
  end

  test "decodes", %{msg: msg, binary: binary} do
    assert RoomMembers.decode(binary) == msg
  end

  test "round trips an empty list" do
    msg = %RoomMembers{room: "secret", members: []}

    assert msg |> RoomMembers.encode() |> IO.iodata_to_binary() |> RoomMembers.decode() == msg
  end
end
