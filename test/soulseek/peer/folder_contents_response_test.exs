defmodule Soulseek.Peer.FolderContentsResponseTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.{Directory, File, FolderContentsResponse}
  alias Soulseek.Wire

  setup do
    msg = %FolderContentsResponse{
      token: 7,
      folder: "Music",
      folders: [
        %Directory{
          name: "Music",
          files: [%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}]
        }
      ]
    }

    payload =
      IO.iodata_to_binary([
        Wire.uint32(7),
        Wire.string("Music"),
        Wire.uint32(1),
        Directory.encode(%Directory{
          name: "Music",
          files: [%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}]
        })
      ])

    %{msg: msg, payload: payload}
  end

  test "encode/1 zlib-compresses the folders", %{msg: msg, payload: payload} do
    assert IO.iodata_to_binary(FolderContentsResponse.encode(msg)) == :zlib.compress(payload)
  end

  test "decode/1 zlib-decompresses into the struct", %{msg: msg, payload: payload} do
    assert FolderContentsResponse.decode(:zlib.compress(payload)) == msg
  end

  test "round trips", %{msg: msg} do
    assert msg
           |> FolderContentsResponse.encode()
           |> IO.iodata_to_binary()
           |> FolderContentsResponse.decode() == msg
  end
end
