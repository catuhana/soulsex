defmodule Soulseek.Server.WishlistIntervalTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.WishlistInterval
  alias Soulseek.Wire

  test "encodes the interval" do
    assert IO.iodata_to_binary(WishlistInterval.encode(%WishlistInterval{interval: 720})) ==
             Wire.uint32(720)
  end

  test "decodes the interval" do
    assert WishlistInterval.decode(Wire.uint32(720)) == %WishlistInterval{interval: 720}
  end

  test "round trips" do
    msg = %WishlistInterval{interval: 120}

    assert msg
           |> WishlistInterval.encode()
           |> IO.iodata_to_binary()
           |> WishlistInterval.decode() == msg
  end
end
