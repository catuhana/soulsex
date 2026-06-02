defmodule Soulseek.Server.UserSearchTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.UserSearch
  alias Soulseek.Wire

  test "encodes username, token, and query" do
    msg = %UserSearch{username: "alice", token: 7, query: "jazz"}

    assert IO.iodata_to_binary(UserSearch.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), Wire.string("jazz")])
  end

  test "decodes username, token, and query" do
    binary = IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), Wire.string("jazz")])

    assert UserSearch.decode(binary) == %UserSearch{username: "alice", token: 7, query: "jazz"}
  end

  test "raises on trailing bytes" do
    binary =
      IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), Wire.string("jazz"), "x"])

    assert_raise MatchError, fn -> UserSearch.decode(binary) end
  end

  test "round trips" do
    msg = %UserSearch{username: "bob", token: 9, query: "soul"}

    assert msg |> UserSearch.encode() |> IO.iodata_to_binary() |> UserSearch.decode() == msg
  end
end
