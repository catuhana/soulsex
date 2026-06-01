defmodule Soulseek.Server.RoomTickerRemovedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomTickerRemoved
  alias Soulseek.Wire

  test "encodes room and username" do
    msg = %RoomTickerRemoved{room: "jazz", username: "alice"}

    assert IO.iodata_to_binary(RoomTickerRemoved.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice")])
  end

  test "decodes room and username" do
    binary = IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice")])

    assert RoomTickerRemoved.decode(binary) == %RoomTickerRemoved{room: "jazz", username: "alice"}
  end

  test "round trips" do
    msg = %RoomTickerRemoved{room: "soul", username: "bob"}

    assert msg
           |> RoomTickerRemoved.encode()
           |> IO.iodata_to_binary()
           |> RoomTickerRemoved.decode() == msg
  end
end
