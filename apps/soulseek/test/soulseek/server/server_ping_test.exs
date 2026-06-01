defmodule Soulseek.Server.ServerPingTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ServerPing

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(ServerPing.encode(%ServerPing{})) == <<>>
  end

  test "decodes an empty binary" do
    assert ServerPing.decode(<<>>) == %ServerPing{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> ServerPing.decode("x") end
  end

  test "round trips" do
    msg = %ServerPing{}

    assert msg |> ServerPing.encode() |> IO.iodata_to_binary() |> ServerPing.decode() == msg
  end
end
