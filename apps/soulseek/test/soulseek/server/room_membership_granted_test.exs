defmodule Soulseek.Server.RoomMembershipGrantedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomMembershipGranted
  alias Soulseek.Wire

  test "encodes the room" do
    msg = %RoomMembershipGranted{room: "secret"}

    assert IO.iodata_to_binary(RoomMembershipGranted.encode(msg)) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert RoomMembershipGranted.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %RoomMembershipGranted{room: "secret"}
  end

  test "round trips" do
    msg = %RoomMembershipGranted{room: "secret"}

    assert msg
           |> RoomMembershipGranted.encode()
           |> IO.iodata_to_binary()
           |> RoomMembershipGranted.decode() == msg
  end
end
