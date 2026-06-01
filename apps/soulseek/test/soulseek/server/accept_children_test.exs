defmodule Soulseek.Server.AcceptChildrenTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.AcceptChildren
  alias Soulseek.Wire

  test "encodes the flag" do
    assert IO.iodata_to_binary(AcceptChildren.encode(%AcceptChildren{accept: true})) ==
             Wire.bool(true)
  end

  test "decodes the flag" do
    assert AcceptChildren.decode(Wire.bool(false)) == %AcceptChildren{accept: false}
  end

  test "round trips" do
    for value <- [true, false] do
      msg = %AcceptChildren{accept: value}

      assert msg |> AcceptChildren.encode() |> IO.iodata_to_binary() |> AcceptChildren.decode() ==
               msg
    end
  end
end
