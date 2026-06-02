defmodule Soulseek.Server.WishlistSearchTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.WishlistSearch
  alias Soulseek.Wire

  test "encodes token and query" do
    msg = %WishlistSearch{token: 7, query: "jazz"}

    assert IO.iodata_to_binary(WishlistSearch.encode(msg)) ==
             IO.iodata_to_binary([Wire.uint32(7), Wire.string("jazz")])
  end

  test "decodes token and query" do
    binary = IO.iodata_to_binary([Wire.uint32(7), Wire.string("jazz")])

    assert WishlistSearch.decode(binary) == %WishlistSearch{token: 7, query: "jazz"}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.uint32(7), Wire.string("jazz"), "x"])

    assert_raise MatchError, fn -> WishlistSearch.decode(binary) end
  end

  test "round trips" do
    msg = %WishlistSearch{token: 9, query: "soul"}

    assert msg |> WishlistSearch.encode() |> IO.iodata_to_binary() |> WishlistSearch.decode() ==
             msg
  end
end
