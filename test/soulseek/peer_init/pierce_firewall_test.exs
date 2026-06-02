defmodule Soulseek.PeerInit.PierceFirewallTest do
  use ExUnit.Case, async: true

  alias Soulseek.PeerInit.PierceFirewall
  alias Soulseek.Wire

  test "encodes the token" do
    assert IO.iodata_to_binary(PierceFirewall.encode(%PierceFirewall{token: 12_345})) ==
             Wire.uint32(12_345)
  end

  test "decodes the token" do
    assert PierceFirewall.decode(Wire.uint32(12_345)) == %PierceFirewall{token: 12_345}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> PierceFirewall.decode(Wire.uint32(1) <> "x") end
  end

  test "round trips" do
    msg = %PierceFirewall{token: 7}

    assert msg |> PierceFirewall.encode() |> IO.iodata_to_binary() |> PierceFirewall.decode() ==
             msg
  end
end
