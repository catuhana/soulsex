defmodule Soulseek.Server.PrivilegedUsersTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.PrivilegedUsers
  alias Soulseek.Wire

  test "encodes the user list" do
    msg = %PrivilegedUsers{users: ["alice", "bob"]}

    assert IO.iodata_to_binary(PrivilegedUsers.encode(msg)) ==
             IO.iodata_to_binary([Wire.uint32(2), Wire.string("alice"), Wire.string("bob")])
  end

  test "decodes the user list" do
    binary = IO.iodata_to_binary([Wire.uint32(2), Wire.string("alice"), Wire.string("bob")])

    assert PrivilegedUsers.decode(binary) == %PrivilegedUsers{users: ["alice", "bob"]}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.uint32(0), "x"])

    assert_raise MatchError, fn -> PrivilegedUsers.decode(binary) end
  end

  test "round trips an empty list" do
    msg = %PrivilegedUsers{users: []}

    assert msg |> PrivilegedUsers.encode() |> IO.iodata_to_binary() |> PrivilegedUsers.decode() ==
             msg
  end
end
