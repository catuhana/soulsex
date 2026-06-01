defmodule Soulseek.Server.RoomTickersTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomTickers
  alias Soulseek.Server.RoomTickers.Ticker
  alias Soulseek.Wire

  setup do
    msg = %RoomTickers{
      room: "jazz",
      tickers: [
        %Ticker{username: "alice", ticker: "hello"},
        %Ticker{username: "bob", ticker: "hi"}
      ]
    }

    binary =
      IO.iodata_to_binary([
        Wire.string("jazz"),
        Wire.uint32(2),
        Wire.string("alice"),
        Wire.string("hello"),
        Wire.string("bob"),
        Wire.string("hi")
      ])

    %{msg: msg, binary: binary}
  end

  test "encodes", %{msg: msg, binary: binary} do
    assert IO.iodata_to_binary(RoomTickers.encode(msg)) == binary
  end

  test "decodes", %{msg: msg, binary: binary} do
    assert RoomTickers.decode(binary) == msg
  end

  test "round trips an empty list" do
    msg = %RoomTickers{room: "empty", tickers: []}

    assert msg |> RoomTickers.encode() |> IO.iodata_to_binary() |> RoomTickers.decode() == msg
  end
end
