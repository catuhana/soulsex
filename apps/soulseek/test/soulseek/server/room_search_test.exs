defmodule Soulseek.Server.RoomSearchTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomSearch
  alias Soulseek.Wire

  test "encodes room, token, and query" do
    msg = %RoomSearch{room: "jazz", token: 7, query: "blue note"}

    assert IO.iodata_to_binary(RoomSearch.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("jazz"), Wire.uint32(7), Wire.string("blue note")])
  end

  test "decodes room, token, and query" do
    binary =
      IO.iodata_to_binary([Wire.string("jazz"), Wire.uint32(7), Wire.string("blue note")])

    assert RoomSearch.decode(binary) == %RoomSearch{room: "jazz", token: 7, query: "blue note"}
  end

  test "raises on trailing bytes" do
    binary =
      IO.iodata_to_binary([Wire.string("jazz"), Wire.uint32(7), Wire.string("q"), "x"])

    assert_raise MatchError, fn -> RoomSearch.decode(binary) end
  end

  test "round trips" do
    msg = %RoomSearch{room: "soul", token: 9, query: "groove"}

    assert msg |> RoomSearch.encode() |> IO.iodata_to_binary() |> RoomSearch.decode() == msg
  end
end
