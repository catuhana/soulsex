defmodule Soulseek.Server.RemoveRoomOperatorTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RemoveRoomOperator
  alias Soulseek.Wire

  test "encodes room and username" do
    msg = %RemoveRoomOperator{room: "secret", username: "alice"}

    assert IO.iodata_to_binary(RemoveRoomOperator.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])
  end

  test "decodes room and username" do
    binary = IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])

    assert RemoveRoomOperator.decode(binary) ==
             %RemoveRoomOperator{room: "secret", username: "alice"}
  end

  test "round trips" do
    msg = %RemoveRoomOperator{room: "secret", username: "bob"}

    assert msg
           |> RemoveRoomOperator.encode()
           |> IO.iodata_to_binary()
           |> RemoveRoomOperator.decode() == msg
  end
end
