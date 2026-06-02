defmodule Soulseek.Server.UnwatchUserTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.UnwatchUser
  alias Soulseek.Wire

  test "encodes the username" do
    assert IO.iodata_to_binary(UnwatchUser.encode(%UnwatchUser{username: "alice"})) ==
             IO.iodata_to_binary(Wire.string("alice"))
  end

  test "decodes the username" do
    assert UnwatchUser.decode(IO.iodata_to_binary(Wire.string("alice"))) ==
             %UnwatchUser{username: "alice"}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary(Wire.string("alice")) <> "extra"

    assert_raise MatchError, fn -> UnwatchUser.decode(binary) end
  end

  test "round trips" do
    msg = %UnwatchUser{username: "bob"}

    assert msg |> UnwatchUser.encode() |> IO.iodata_to_binary() |> UnwatchUser.decode() == msg
  end
end
