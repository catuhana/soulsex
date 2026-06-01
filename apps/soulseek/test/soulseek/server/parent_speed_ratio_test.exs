defmodule Soulseek.Server.ParentSpeedRatioTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ParentSpeedRatio
  alias Soulseek.Wire

  test "encodes the ratio" do
    assert IO.iodata_to_binary(ParentSpeedRatio.encode(%ParentSpeedRatio{ratio: 50})) ==
             Wire.uint32(50)
  end

  test "decodes the ratio" do
    assert ParentSpeedRatio.decode(Wire.uint32(50)) == %ParentSpeedRatio{ratio: 50}
  end

  test "round trips" do
    msg = %ParentSpeedRatio{ratio: 50}

    assert msg |> ParentSpeedRatio.encode() |> IO.iodata_to_binary() |> ParentSpeedRatio.decode() ==
             msg
  end
end
