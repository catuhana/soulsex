defmodule Soulseek.Server.BranchLevelTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.BranchLevel
  alias Soulseek.Wire

  test "encodes the level" do
    assert IO.iodata_to_binary(BranchLevel.encode(%BranchLevel{level: 3})) == Wire.uint32(3)
  end

  test "decodes the level" do
    assert BranchLevel.decode(Wire.uint32(3)) == %BranchLevel{level: 3}
  end

  test "round trips" do
    msg = %BranchLevel{level: 0}

    assert msg |> BranchLevel.encode() |> IO.iodata_to_binary() |> BranchLevel.decode() == msg
  end
end
