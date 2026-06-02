defmodule Soulseek.Server.SetStatusTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SetStatus
  alias Soulseek.Wire

  test "encodes the status as an int32" do
    assert IO.iodata_to_binary(SetStatus.encode(%SetStatus{status: :online})) == Wire.int32(2)
  end

  test "decodes the status" do
    assert SetStatus.decode(Wire.int32(1)) == %SetStatus{status: :away}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> SetStatus.decode(Wire.int32(2) <> "x") end
  end

  test "round trips" do
    for status <- [:offline, :away, :online] do
      msg = %SetStatus{status: status}

      assert msg |> SetStatus.encode() |> IO.iodata_to_binary() |> SetStatus.decode() == msg
    end
  end
end
