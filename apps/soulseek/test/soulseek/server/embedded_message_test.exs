defmodule Soulseek.Server.EmbeddedMessageTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.EmbeddedMessage
  alias Soulseek.Wire

  test "encodes code and message" do
    msg = %EmbeddedMessage{code: 3, message: <<1, 2, 3>>}

    assert IO.iodata_to_binary(EmbeddedMessage.encode(msg)) ==
             IO.iodata_to_binary([Wire.uint8(3), Wire.bytes(<<1, 2, 3>>)])
  end

  test "decodes code and message" do
    binary = IO.iodata_to_binary([Wire.uint8(3), Wire.bytes(<<1, 2, 3>>)])

    assert EmbeddedMessage.decode(binary) == %EmbeddedMessage{code: 3, message: <<1, 2, 3>>}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.uint8(3), Wire.bytes(<<1, 2, 3>>), "x"])

    assert_raise MatchError, fn -> EmbeddedMessage.decode(binary) end
  end

  test "round trips" do
    msg = %EmbeddedMessage{code: 5, message: <<9, 9, 9, 9>>}

    assert msg |> EmbeddedMessage.encode() |> IO.iodata_to_binary() |> EmbeddedMessage.decode() ==
             msg
  end
end
