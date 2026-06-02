defmodule Soulseek.Peer.TransferRequestTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.TransferRequest
  alias Soulseek.Wire

  describe "upload (includes file size)" do
    test "encodes" do
      msg = %TransferRequest{direction: :upload, token: 7, filename: "a.mp3", file_size: 4096}

      assert IO.iodata_to_binary(TransferRequest.encode(msg)) ==
               IO.iodata_to_binary([
                 Wire.uint32(1),
                 Wire.uint32(7),
                 Wire.string("a.mp3"),
                 Wire.uint64(4096)
               ])
    end

    test "decodes" do
      binary =
        IO.iodata_to_binary([
          Wire.uint32(1),
          Wire.uint32(7),
          Wire.string("a.mp3"),
          Wire.uint64(4096)
        ])

      assert TransferRequest.decode(binary) ==
               %TransferRequest{direction: :upload, token: 7, filename: "a.mp3", file_size: 4096}
    end

    test "round trips" do
      msg = %TransferRequest{direction: :upload, token: 1, filename: "x", file_size: 9}

      assert msg |> TransferRequest.encode() |> IO.iodata_to_binary() |> TransferRequest.decode() ==
               msg
    end
  end

  describe "download (no file size)" do
    test "encodes without a file size" do
      msg = %TransferRequest{direction: :download, token: 7, filename: "a.mp3"}

      assert IO.iodata_to_binary(TransferRequest.encode(msg)) ==
               IO.iodata_to_binary([Wire.uint32(0), Wire.uint32(7), Wire.string("a.mp3")])
    end

    test "decodes with a nil file size" do
      binary = IO.iodata_to_binary([Wire.uint32(0), Wire.uint32(7), Wire.string("a.mp3")])

      assert TransferRequest.decode(binary) ==
               %TransferRequest{direction: :download, token: 7, filename: "a.mp3", file_size: nil}
    end
  end
end
