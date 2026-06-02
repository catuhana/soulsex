defmodule Soulseek.Server.CancelRoomOwnershipTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.CancelRoomOwnership
  alias Soulseek.Wire

  test "encodes the room" do
    assert IO.iodata_to_binary(CancelRoomOwnership.encode(%CancelRoomOwnership{room: "secret"})) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert CancelRoomOwnership.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %CancelRoomOwnership{room: "secret"}
  end

  test "round trips" do
    msg = %CancelRoomOwnership{room: "secret"}

    assert msg
           |> CancelRoomOwnership.encode()
           |> IO.iodata_to_binary()
           |> CancelRoomOwnership.decode() == msg
  end
end
