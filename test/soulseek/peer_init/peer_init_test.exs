defmodule Soulseek.PeerInit.PeerInitTest do
  use ExUnit.Case, async: true

  alias Soulseek.PeerInit.PeerInit
  alias Soulseek.Wire

  test "encodes username, type, and token" do
    msg = %PeerInit{username: "alice", type: :peer, token: 0}

    assert IO.iodata_to_binary(PeerInit.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("alice"), Wire.string("P"), Wire.uint32(0)])
  end

  test "decodes username, type, and token" do
    binary = IO.iodata_to_binary([Wire.string("alice"), Wire.string("F"), Wire.uint32(0)])

    assert PeerInit.decode(binary) == %PeerInit{username: "alice", type: :file, token: 0}
  end

  test "defaults the token to zero" do
    assert %PeerInit{username: "alice", type: :peer}.token == 0
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.string("alice"), Wire.string("P"), Wire.uint32(0), "x"])

    assert_raise MatchError, fn -> PeerInit.decode(binary) end
  end

  test "round trips" do
    msg = %PeerInit{username: "bob", type: :distributed, token: 0}

    assert msg |> PeerInit.encode() |> IO.iodata_to_binary() |> PeerInit.decode() == msg
  end
end
