defmodule Soulseek.Server.UserLeftRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.UserLeftRoom
  alias Soulseek.Wire

  test "encodes room and username" do
    msg = %UserLeftRoom{room: "jazz", username: "alice"}

    assert IO.iodata_to_binary(UserLeftRoom.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice")])
  end

  test "decodes room and username" do
    binary = IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice")])

    assert UserLeftRoom.decode(binary) == %UserLeftRoom{room: "jazz", username: "alice"}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), "x"])

    assert_raise MatchError, fn -> UserLeftRoom.decode(binary) end
  end

  test "round trips" do
    msg = %UserLeftRoom{room: "jazz", username: "bob"}

    assert msg |> UserLeftRoom.encode() |> IO.iodata_to_binary() |> UserLeftRoom.decode() == msg
  end
end
