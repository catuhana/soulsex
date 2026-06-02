defmodule Soulseek.Peer.FileSearchResponseTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.{File, FileSearchResponse}
  alias Soulseek.Wire

  setup do
    msg = %FileSearchResponse{
      username: "alice",
      token: 7,
      results: [%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}],
      slot_free: true,
      avg_speed: 500,
      queue_length: 3,
      private_results: [%File{filename: "b.flac", size: 2, extension: "flac", attributes: []}]
    }

    payload =
      IO.iodata_to_binary([
        Wire.string("alice"),
        Wire.uint32(7),
        Wire.uint32(1),
        File.encode(%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}),
        Wire.bool(true),
        Wire.uint32(500),
        Wire.uint32(3),
        Wire.uint32(0),
        Wire.uint32(1),
        File.encode(%File{filename: "b.flac", size: 2, extension: "flac", attributes: []})
      ])

    %{msg: msg, payload: payload}
  end

  test "encode/1 zlib-compresses the results", %{msg: msg, payload: payload} do
    assert IO.iodata_to_binary(FileSearchResponse.encode(msg)) == :zlib.compress(payload)
  end

  test "decode/1 zlib-decompresses into the struct", %{msg: msg, payload: payload} do
    assert FileSearchResponse.decode(:zlib.compress(payload)) == msg
  end

  test "round trips", %{msg: msg} do
    assert msg
           |> FileSearchResponse.encode()
           |> IO.iodata_to_binary()
           |> FileSearchResponse.decode() == msg
  end
end
