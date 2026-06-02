defmodule Soulseek.Server.RoomMembershipRevokedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomMembershipRevoked
  alias Soulseek.Wire

  test "encodes the room" do
    msg = %RoomMembershipRevoked{room: "secret"}

    assert IO.iodata_to_binary(RoomMembershipRevoked.encode(msg)) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert RoomMembershipRevoked.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %RoomMembershipRevoked{room: "secret"}
  end

  test "round trips" do
    msg = %RoomMembershipRevoked{room: "secret"}

    assert msg
           |> RoomMembershipRevoked.encode()
           |> IO.iodata_to_binary()
           |> RoomMembershipRevoked.decode() == msg
  end
end
