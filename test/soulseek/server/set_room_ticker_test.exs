defmodule Soulseek.Server.SetRoomTickerTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SetRoomTicker
  alias Soulseek.Wire

  test "encodes room and ticker" do
    msg = %SetRoomTicker{room: "jazz", ticker: "hello"}

    assert IO.iodata_to_binary(SetRoomTicker.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("jazz"), Wire.string("hello")])
  end

  test "decodes room and ticker" do
    binary = IO.iodata_to_binary([Wire.string("jazz"), Wire.string("hello")])

    assert SetRoomTicker.decode(binary) == %SetRoomTicker{room: "jazz", ticker: "hello"}
  end

  test "round trips an empty ticker" do
    msg = %SetRoomTicker{room: "jazz", ticker: ""}

    assert msg |> SetRoomTicker.encode() |> IO.iodata_to_binary() |> SetRoomTicker.decode() == msg
  end
end
