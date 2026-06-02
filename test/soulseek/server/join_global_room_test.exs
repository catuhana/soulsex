defmodule Soulseek.Server.JoinGlobalRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.JoinGlobalRoom

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(JoinGlobalRoom.encode(%JoinGlobalRoom{})) == <<>>
  end

  test "decodes an empty binary" do
    assert JoinGlobalRoom.decode(<<>>) == %JoinGlobalRoom{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> JoinGlobalRoom.decode("x") end
  end

  test "round trips" do
    msg = %JoinGlobalRoom{}

    assert msg |> JoinGlobalRoom.encode() |> IO.iodata_to_binary() |> JoinGlobalRoom.decode() ==
             msg
  end
end
