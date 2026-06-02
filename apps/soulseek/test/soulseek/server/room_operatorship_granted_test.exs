defmodule Soulseek.Server.RoomOperatorshipGrantedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomOperatorshipGranted
  alias Soulseek.Wire

  test "encodes the room" do
    msg = %RoomOperatorshipGranted{room: "secret"}

    assert IO.iodata_to_binary(RoomOperatorshipGranted.encode(msg)) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert RoomOperatorshipGranted.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %RoomOperatorshipGranted{room: "secret"}
  end

  test "round trips" do
    msg = %RoomOperatorshipGranted{room: "secret"}

    assert msg
           |> RoomOperatorshipGranted.encode()
           |> IO.iodata_to_binary()
           |> RoomOperatorshipGranted.decode() == msg
  end
end
