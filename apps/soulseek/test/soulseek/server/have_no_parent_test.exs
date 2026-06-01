defmodule Soulseek.Server.HaveNoParentTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.HaveNoParent
  alias Soulseek.Wire

  test "encodes the flag" do
    assert IO.iodata_to_binary(HaveNoParent.encode(%HaveNoParent{no_parent: true})) ==
             Wire.bool(true)
  end

  test "decodes the flag" do
    assert HaveNoParent.decode(Wire.bool(false)) == %HaveNoParent{no_parent: false}
  end

  test "round trips" do
    for value <- [true, false] do
      msg = %HaveNoParent{no_parent: value}

      assert msg |> HaveNoParent.encode() |> IO.iodata_to_binary() |> HaveNoParent.decode() == msg
    end
  end
end
