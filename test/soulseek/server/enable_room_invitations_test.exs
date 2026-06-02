defmodule Soulseek.Server.EnableRoomInvitationsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.EnableRoomInvitations
  alias Soulseek.Wire

  test "encodes the flag" do
    assert IO.iodata_to_binary(EnableRoomInvitations.encode(%EnableRoomInvitations{enable: true})) ==
             Wire.bool(true)
  end

  test "decodes the flag" do
    assert EnableRoomInvitations.decode(Wire.bool(false)) ==
             %EnableRoomInvitations{enable: false}
  end

  test "round trips" do
    for value <- [true, false] do
      msg = %EnableRoomInvitations{enable: value}

      assert msg
             |> EnableRoomInvitations.encode()
             |> IO.iodata_to_binary()
             |> EnableRoomInvitations.decode() == msg
    end
  end
end
