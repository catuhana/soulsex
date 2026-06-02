defmodule Soulseek.Peer.PlaceInQueueRequestTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.PlaceInQueueRequest
  alias Soulseek.Wire

  test "encodes the filename" do
    assert IO.iodata_to_binary(
             PlaceInQueueRequest.encode(%PlaceInQueueRequest{filename: "a.mp3"})
           ) ==
             IO.iodata_to_binary(Wire.string("a.mp3"))
  end

  test "decodes the filename" do
    assert PlaceInQueueRequest.decode(IO.iodata_to_binary(Wire.string("a.mp3"))) ==
             %PlaceInQueueRequest{filename: "a.mp3"}
  end

  test "round trips" do
    msg = %PlaceInQueueRequest{filename: "b.flac"}

    assert msg
           |> PlaceInQueueRequest.encode()
           |> IO.iodata_to_binary()
           |> PlaceInQueueRequest.decode() == msg
  end
end
