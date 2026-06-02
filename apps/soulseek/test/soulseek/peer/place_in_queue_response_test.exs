defmodule Soulseek.Peer.PlaceInQueueResponseTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.PlaceInQueueResponse
  alias Soulseek.Wire

  test "encodes filename and place" do
    msg = %PlaceInQueueResponse{filename: "a.mp3", place: 3}

    assert IO.iodata_to_binary(PlaceInQueueResponse.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("a.mp3"), Wire.uint32(3)])
  end

  test "decodes filename and place" do
    binary = IO.iodata_to_binary([Wire.string("a.mp3"), Wire.uint32(3)])

    assert PlaceInQueueResponse.decode(binary) ==
             %PlaceInQueueResponse{filename: "a.mp3", place: 3}
  end

  test "round trips" do
    msg = %PlaceInQueueResponse{filename: "b.flac", place: 0}

    assert msg
           |> PlaceInQueueResponse.encode()
           |> IO.iodata_to_binary()
           |> PlaceInQueueResponse.decode() == msg
  end
end
