defmodule Soulseek.Server.RoomOperatorshipRevokedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomOperatorshipRevoked
  alias Soulseek.Wire

  test "encodes the room" do
    msg = %RoomOperatorshipRevoked{room: "secret"}

    assert IO.iodata_to_binary(RoomOperatorshipRevoked.encode(msg)) ==
             IO.iodata_to_binary(Wire.string("secret"))
  end

  test "decodes the room" do
    assert RoomOperatorshipRevoked.decode(IO.iodata_to_binary(Wire.string("secret"))) ==
             %RoomOperatorshipRevoked{room: "secret"}
  end

  test "round trips" do
    msg = %RoomOperatorshipRevoked{room: "secret"}

    assert msg
           |> RoomOperatorshipRevoked.encode()
           |> IO.iodata_to_binary()
           |> RoomOperatorshipRevoked.decode() == msg
  end
end
