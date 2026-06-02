defmodule Soulseek.Server.CantCreateRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.CantCreateRoom
  alias Soulseek.Wire

  test "encodes the room" do
    assert IO.iodata_to_binary(CantCreateRoom.encode(%CantCreateRoom{room: "secret"})) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert CantCreateRoom.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %CantCreateRoom{room: "secret"}
  end

  test "round trips" do
    msg = %CantCreateRoom{room: "secret"}

    assert msg |> CantCreateRoom.encode() |> IO.iodata_to_binary() |> CantCreateRoom.decode() ==
             msg
  end
end
