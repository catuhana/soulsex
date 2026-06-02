defmodule Soulseek.Server.UserJoinedRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.UserJoinedRoom
  alias Soulseek.Wire

  setup do
    msg = %UserJoinedRoom{
      room: "jazz",
      username: "alice",
      status: :online,
      avg_speed: 1200,
      upload_num: 42,
      unknown: 0,
      files: 1000,
      dirs: 50,
      slots_full: true,
      country_code: "US"
    }

    binary =
      IO.iodata_to_binary([
        Wire.string("jazz"),
        Wire.string("alice"),
        Wire.uint32(2),
        Wire.uint32(1200),
        Wire.uint32(42),
        Wire.uint32(0),
        Wire.uint32(1000),
        Wire.uint32(50),
        Wire.uint32(1),
        Wire.string("US")
      ])

    %{msg: msg, binary: binary}
  end

  test "encodes all fields", %{msg: msg, binary: binary} do
    assert IO.iodata_to_binary(UserJoinedRoom.encode(msg)) == binary
  end

  test "decodes all fields", %{msg: msg, binary: binary} do
    assert UserJoinedRoom.decode(binary) == msg
  end

  test "raises on trailing bytes", %{binary: binary} do
    assert_raise MatchError, fn -> UserJoinedRoom.decode(binary <> "x") end
  end

  test "round trips", %{msg: msg} do
    assert msg |> UserJoinedRoom.encode() |> IO.iodata_to_binary() |> UserJoinedRoom.decode() ==
             msg
  end
end
