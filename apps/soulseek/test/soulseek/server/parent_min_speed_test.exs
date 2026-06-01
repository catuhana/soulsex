defmodule Soulseek.Server.ParentMinSpeedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ParentMinSpeed
  alias Soulseek.Wire

  test "encodes the speed" do
    assert IO.iodata_to_binary(ParentMinSpeed.encode(%ParentMinSpeed{speed: 1500})) ==
             Wire.uint32(1500)
  end

  test "decodes the speed" do
    assert ParentMinSpeed.decode(Wire.uint32(1500)) == %ParentMinSpeed{speed: 1500}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> ParentMinSpeed.decode(Wire.uint32(1) <> "x") end
  end

  test "round trips" do
    msg = %ParentMinSpeed{speed: 1500}

    assert msg |> ParentMinSpeed.encode() |> IO.iodata_to_binary() |> ParentMinSpeed.decode() ==
             msg
  end
end
