defmodule Soulseek.Distributed.BranchLevelTest do
  use ExUnit.Case, async: true

  alias Soulseek.Distributed.BranchLevel
  alias Soulseek.Wire

  test "encodes the level" do
    assert IO.iodata_to_binary(BranchLevel.encode(%BranchLevel{branch_level: 3})) ==
             IO.iodata_to_binary(Wire.int32(3))
  end

  test "decodes the level" do
    assert BranchLevel.decode(IO.iodata_to_binary(Wire.int32(0))) == %BranchLevel{branch_level: 0}
  end

  test "round trips a negative level" do
    msg = %BranchLevel{branch_level: -1}

    assert msg |> BranchLevel.encode() |> IO.iodata_to_binary() |> BranchLevel.decode() == msg
  end
end
