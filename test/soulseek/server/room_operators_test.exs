defmodule Soulseek.Server.RoomOperatorsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomOperators
  alias Soulseek.Wire

  setup do
    msg = %RoomOperators{room: "secret", operators: ["alice", "bob"]}

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
    assert IO.iodata_to_binary(RoomOperators.encode(msg)) == binary
  end

  test "decodes", %{msg: msg, binary: binary} do
    assert RoomOperators.decode(binary) == msg
  end

  test "round trips an empty list" do
    msg = %RoomOperators{room: "secret", operators: []}

    assert msg |> RoomOperators.encode() |> IO.iodata_to_binary() |> RoomOperators.decode() == msg
  end
end
