defmodule Soulseek.Server.GlobalRoomMessageTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.GlobalRoomMessage
  alias Soulseek.Wire

  test "encodes room, username, and message" do
    msg = %GlobalRoomMessage{room: "jazz", username: "alice", message: "hi"}

    assert IO.iodata_to_binary(GlobalRoomMessage.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hi")])
  end

  test "decodes room, username, and message" do
    binary =
      IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hi")])

    assert GlobalRoomMessage.decode(binary) ==
             %GlobalRoomMessage{room: "jazz", username: "alice", message: "hi"}
  end

  test "raises on trailing bytes" do
    binary =
      IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hi"), "x"])

    assert_raise MatchError, fn -> GlobalRoomMessage.decode(binary) end
  end

  test "round trips" do
    msg = %GlobalRoomMessage{room: "soul", username: "bob", message: "yo"}

    assert msg
           |> GlobalRoomMessage.encode()
           |> IO.iodata_to_binary()
           |> GlobalRoomMessage.decode() == msg
  end
end
