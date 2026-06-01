defmodule Soulseek.Server.LeaveRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.LeaveRoom
  alias Soulseek.Wire

  test "encodes the room" do
    assert IO.iodata_to_binary(LeaveRoom.encode(%LeaveRoom{room: "jazz"})) ==
             IO.iodata_to_binary(Wire.string("jazz"))
  end

  test "decodes the room" do
    assert LeaveRoom.decode(IO.iodata_to_binary(Wire.string("jazz"))) == %LeaveRoom{room: "jazz"}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary(Wire.string("jazz")) <> "x"

    assert_raise MatchError, fn -> LeaveRoom.decode(binary) end
  end

  test "round trips" do
    msg = %LeaveRoom{room: "jazz"}

    assert msg |> LeaveRoom.encode() |> IO.iodata_to_binary() |> LeaveRoom.decode() == msg
  end
end
