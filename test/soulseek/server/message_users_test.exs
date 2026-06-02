defmodule Soulseek.Server.MessageUsersTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.MessageUsers
  alias Soulseek.Wire

  setup do
    msg = %MessageUsers{usernames: ["alice", "bob"], message: "hello"}

    binary =
      IO.iodata_to_binary([
        Wire.uint32(2),
        Wire.string("alice"),
        Wire.string("bob"),
        Wire.string("hello")
      ])

    %{msg: msg, binary: binary}
  end

  test "encodes", %{msg: msg, binary: binary} do
    assert IO.iodata_to_binary(MessageUsers.encode(msg)) == binary
  end

  test "decodes", %{msg: msg, binary: binary} do
    assert MessageUsers.decode(binary) == msg
  end

  test "raises on trailing bytes", %{binary: binary} do
    assert_raise MatchError, fn -> MessageUsers.decode(binary <> "x") end
  end

  test "round trips an empty user list" do
    msg = %MessageUsers{usernames: [], message: "hi"}

    assert msg |> MessageUsers.encode() |> IO.iodata_to_binary() |> MessageUsers.decode() == msg
  end
end
