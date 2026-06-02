defmodule Soulseek.Server.RemoveRoomMemberTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RemoveRoomMember
  alias Soulseek.Wire

  test "encodes room and username" do
    msg = %RemoveRoomMember{room: "secret", username: "alice"}

    assert IO.iodata_to_binary(RemoveRoomMember.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])
  end

  test "decodes room and username" do
    binary = IO.iodata_to_binary([Wire.string("secret"), Wire.string("alice")])

    assert RemoveRoomMember.decode(binary) == %RemoveRoomMember{room: "secret", username: "alice"}
  end

  test "round trips" do
    msg = %RemoveRoomMember{room: "secret", username: "bob"}

    assert msg
           |> RemoveRoomMember.encode()
           |> IO.iodata_to_binary()
           |> RemoveRoomMember.decode() == msg
  end
end
