defmodule Soulseek.Server.ReloggedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.Relogged

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(Relogged.encode(%Relogged{})) == <<>>
  end

  test "decodes an empty binary" do
    assert Relogged.decode(<<>>) == %Relogged{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> Relogged.decode("x") end
  end

  test "round trips" do
    msg = %Relogged{}

    assert msg |> Relogged.encode() |> IO.iodata_to_binary() |> Relogged.decode() == msg
  end
end
