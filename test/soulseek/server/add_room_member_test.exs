defmodule Soulseek.Server.AddRoomMemberTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.AddRoomMember
  alias Soulseek.Wire

  test "encodes room and username" do
    msg = %AddRoomMember{room: "secret", username: "alice"}

    assert IO.iodata_to_binary(AddRoomMember.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])
  end

  test "decodes room and username" do
    binary = IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])

    assert AddRoomMember.decode(binary) == %AddRoomMember{room: "secret", username: "alice"}
  end

  test "round trips" do
    msg = %AddRoomMember{room: "secret", username: "bob"}

    assert msg |> AddRoomMember.encode() |> IO.iodata_to_binary() |> AddRoomMember.decode() == msg
  end
end
