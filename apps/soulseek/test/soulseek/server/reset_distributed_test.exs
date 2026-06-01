defmodule Soulseek.Server.ResetDistributedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ResetDistributed

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(ResetDistributed.encode(%ResetDistributed{})) == <<>>
  end

  test "decodes an empty binary" do
    assert ResetDistributed.decode(<<>>) == %ResetDistributed{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> ResetDistributed.decode("x") end
  end

  test "round trips" do
    msg = %ResetDistributed{}

    assert msg
           |> ResetDistributed.encode()
           |> IO.iodata_to_binary()
           |> ResetDistributed.decode() == msg
  end
end
