defmodule Soulseek.Server.AdminMessageTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.AdminMessage
  alias Soulseek.Wire

  test "encodes the message" do
    assert IO.iodata_to_binary(AdminMessage.encode(%AdminMessage{message: "down at 5pm"})) ==
             IO.iodata_to_binary(Wire.string("down at 5pm"))
  end

  test "decodes the message" do
    assert AdminMessage.decode(IO.iodata_to_binary(Wire.string("down at 5pm"))) ==
             %AdminMessage{message: "down at 5pm"}
  end

  test "raises on trailing bytes" do
    assert_raise MatchError, fn ->
      AdminMessage.decode(IO.iodata_to_binary(Wire.string("hi")) <> "x")
    end
  end

  test "round trips" do
    msg = %AdminMessage{message: "maintenance tonight"}

    assert msg |> AdminMessage.encode() |> IO.iodata_to_binary() |> AdminMessage.decode() == msg
  end
end
