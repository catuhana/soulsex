defmodule Soulseek.Server.GivePrivilegesTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.GivePrivileges
  alias Soulseek.Wire

  test "encodes username and days" do
    msg = %GivePrivileges{username: "alice", days: 7}

    assert IO.iodata_to_binary(GivePrivileges.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7)])
  end

  test "decodes username and days" do
    binary = IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7)])

    assert GivePrivileges.decode(binary) == %GivePrivileges{username: "alice", days: 7}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), "x"])

    assert_raise MatchError, fn -> GivePrivileges.decode(binary) end
  end

  test "round trips" do
    msg = %GivePrivileges{username: "bob", days: 30}

    assert msg |> GivePrivileges.encode() |> IO.iodata_to_binary() |> GivePrivileges.decode() ==
             msg
  end
end
