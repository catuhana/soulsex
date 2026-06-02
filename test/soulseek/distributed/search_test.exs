defmodule Soulseek.Distributed.SearchTest do
  use ExUnit.Case, async: true

  alias Soulseek.Distributed.Search
  alias Soulseek.Wire

  test "encodes with the leading identifier" do
    msg = %Search{username: "alice", token: 7, query: "song"}

    assert IO.iodata_to_binary(Search.encode(msg)) ==
             IO.iodata_to_binary([
               Wire.uint32(49),
               Wire.string("alice"),
               Wire.uint32(7),
               Wire.string("song")
             ])
  end

  test "decodes" do
    binary =
      IO.iodata_to_binary([
        Wire.uint32(49),
        Wire.string("alice"),
        Wire.uint32(7),
        Wire.string("song")
      ])

    assert Search.decode(binary) == %Search{username: "alice", token: 7, query: "song"}
  end

  test "rejects a non-49 identifier" do
    binary =
      IO.iodata_to_binary([
        Wire.uint32(50),
        Wire.string("alice"),
        Wire.uint32(7),
        Wire.string("song")
      ])

    assert_raise MatchError, fn -> Search.decode(binary) end
  end

  test "round trips" do
    msg = %Search{username: "bob", token: 99, query: "another query"}

    assert msg |> Search.encode() |> IO.iodata_to_binary() |> Search.decode() == msg
  end
end
