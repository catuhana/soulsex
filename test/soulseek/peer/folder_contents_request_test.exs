defmodule Soulseek.Peer.FolderContentsRequestTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.FolderContentsRequest
  alias Soulseek.Wire

  test "encodes token and folder" do
    msg = %FolderContentsRequest{token: 7, folder: "Music"}

    assert IO.iodata_to_binary(FolderContentsRequest.encode(msg)) ==
             IO.iodata_to_binary([Wire.uint32(7), Wire.string("Music")])
  end

  test "decodes token and folder" do
    binary = IO.iodata_to_binary([Wire.uint32(7), Wire.string("Music")])

    assert FolderContentsRequest.decode(binary) ==
             %FolderContentsRequest{token: 7, folder: "Music"}
  end

  test "round trips" do
    msg = %FolderContentsRequest{token: 9, folder: "Music/Jazz"}

    assert msg
           |> FolderContentsRequest.encode()
           |> IO.iodata_to_binary()
           |> FolderContentsRequest.decode() == msg
  end
end
