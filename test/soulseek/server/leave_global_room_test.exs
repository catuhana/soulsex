defmodule Soulseek.Server.LeaveGlobalRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.LeaveGlobalRoom

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(LeaveGlobalRoom.encode(%LeaveGlobalRoom{})) == <<>>
  end

  test "decodes an empty binary" do
    assert LeaveGlobalRoom.decode(<<>>) == %LeaveGlobalRoom{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> LeaveGlobalRoom.decode("x") end
  end

  test "round trips" do
    msg = %LeaveGlobalRoom{}

    assert msg |> LeaveGlobalRoom.encode() |> IO.iodata_to_binary() |> LeaveGlobalRoom.decode() ==
             msg
  end
end
