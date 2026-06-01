defmodule Soulseek.Server.MessageAckedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.MessageAcked
  alias Soulseek.Wire

  test "encodes the message id" do
    assert IO.iodata_to_binary(MessageAcked.encode(%MessageAcked{message_id: 42})) ==
             Wire.uint32(42)
  end

  test "decodes the message id" do
    assert MessageAcked.decode(Wire.uint32(42)) == %MessageAcked{message_id: 42}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> MessageAcked.decode(Wire.uint32(42) <> "x") end
  end

  test "round trips" do
    msg = %MessageAcked{message_id: 7}

    assert msg |> MessageAcked.encode() |> IO.iodata_to_binary() |> MessageAcked.decode() == msg
  end
end
