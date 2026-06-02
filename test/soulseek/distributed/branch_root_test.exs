defmodule Soulseek.Distributed.BranchRootTest do
  use ExUnit.Case, async: true

  alias Soulseek.Distributed.BranchRoot
  alias Soulseek.Wire

  test "encodes the root" do
    assert IO.iodata_to_binary(BranchRoot.encode(%BranchRoot{branch_root: "alice"})) ==
             IO.iodata_to_binary(Wire.string("alice"))
  end

  test "decodes the root" do
    assert BranchRoot.decode(IO.iodata_to_binary(Wire.string("alice"))) ==
             %BranchRoot{branch_root: "alice"}
  end

  test "round trips" do
    msg = %BranchRoot{branch_root: "bob"}

    assert msg |> BranchRoot.encode() |> IO.iodata_to_binary() |> BranchRoot.decode() == msg
  end
end
