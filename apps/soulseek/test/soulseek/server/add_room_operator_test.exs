defmodule Soulseek.Server.AddRoomOperatorTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.AddRoomOperator
  alias Soulseek.Wire

  test "encodes room and username" do
    msg = %AddRoomOperator{room: "secret", username: "alice"}

    assert IO.iodata_to_binary(AddRoomOperator.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])
  end

  test "decodes room and username" do
    binary = IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])

    assert AddRoomOperator.decode(binary) == %AddRoomOperator{room: "secret", username: "alice"}
  end

  test "round trips" do
    msg = %AddRoomOperator{room: "secret", username: "bob"}

    assert msg
           |> AddRoomOperator.encode()
           |> IO.iodata_to_binary()
           |> AddRoomOperator.decode() == msg
  end
end
