defmodule Soulseek.Peer.SharedFileListResponseTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.{Directory, File, SharedFileListResponse}
  alias Soulseek.Wire

  setup do
    msg = %SharedFileListResponse{
      directories: [
        %Directory{
          name: "Music",
          files: [%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}]
        }
      ],
      private_directories: [
        %Directory{name: "Private", files: []}
      ]
    }

    payload =
      IO.iodata_to_binary([
        Wire.uint32(1),
        Directory.encode(%Directory{
          name: "Music",
          files: [%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}]
        }),
        Wire.uint32(0),
        Wire.uint32(1),
        Directory.encode(%Directory{name: "Private", files: []})
      ])

    %{msg: msg, payload: payload}
  end

  test "encode/1 zlib-compresses the directories", %{msg: msg, payload: payload} do
    assert IO.iodata_to_binary(SharedFileListResponse.encode(msg)) == :zlib.compress(payload)
  end

  test "decode/1 zlib-decompresses into the struct", %{msg: msg, payload: payload} do
    assert SharedFileListResponse.decode(:zlib.compress(payload)) == msg
  end

  test "round trips", %{msg: msg} do
    assert msg
           |> SharedFileListResponse.encode()
           |> IO.iodata_to_binary()
           |> SharedFileListResponse.decode() == msg
  end
end
