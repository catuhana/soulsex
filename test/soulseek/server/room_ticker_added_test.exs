defmodule Soulseek.Server.RoomTickerAddedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomTickerAdded
  alias Soulseek.Wire

  test "encodes room, username, and ticker" do
    msg = %RoomTickerAdded{room: "jazz", username: "alice", ticker: "hello"}

    assert IO.iodata_to_binary(RoomTickerAdded.encode(msg)) ==
             IO.iodata_to_binary([
               Wire.string("jazz"),
               Wire.string("alice"),
               Wire.string("hello")
             ])
  end

  test "decodes room, username, and ticker" do
    binary =
      IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hello")])

    assert RoomTickerAdded.decode(binary) ==
             %RoomTickerAdded{room: "jazz", username: "alice", ticker: "hello"}
  end

  test "raises on trailing bytes" do
    binary =
      IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hi"), "x"])

    assert_raise MatchError, fn -> RoomTickerAdded.decode(binary) end
  end

  test "round trips" do
    msg = %RoomTickerAdded{room: "soul", username: "bob", ticker: "yo"}

    assert msg
           |> RoomTickerAdded.encode()
           |> IO.iodata_to_binary()
           |> RoomTickerAdded.decode() == msg
  end
end
