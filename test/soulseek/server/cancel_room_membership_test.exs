defmodule Soulseek.Server.CancelRoomMembershipTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.CancelRoomMembership
  alias Soulseek.Wire

  test "encodes the room" do
    assert IO.iodata_to_binary(CancelRoomMembership.encode(%CancelRoomMembership{room: "secret"})) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert CancelRoomMembership.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %CancelRoomMembership{room: "secret"}
  end

  test "round trips" do
    msg = %CancelRoomMembership{room: "secret"}

    assert msg
           |> CancelRoomMembership.encode()
           |> IO.iodata_to_binary()
           |> CancelRoomMembership.decode() == msg
  end
end
