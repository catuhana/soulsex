defmodule Soulseek.Peer.UploadResponseTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.UploadResponse
  alias Soulseek.Wire

  describe "allowed" do
    test "encodes without a reason" do
      msg = %UploadResponse{token: 7, allowed: true}

      assert IO.iodata_to_binary(UploadResponse.encode(msg)) ==
               IO.iodata_to_binary([Wire.uint32(7), Wire.bool(true)])
    end

    test "decodes" do
      binary = IO.iodata_to_binary([Wire.uint32(7), Wire.bool(true)])

      assert UploadResponse.decode(binary) == %UploadResponse{
               token: 7,
               allowed: true,
               reason: nil
             }
    end
  end

  describe "denied" do
    test "encodes with a reason" do
      msg = %UploadResponse{token: 7, allowed: false, reason: :queued}

      assert IO.iodata_to_binary(UploadResponse.encode(msg)) ==
               IO.iodata_to_binary([Wire.uint32(7), Wire.bool(false), Wire.string("Queued")])
    end

    test "decodes the reason" do
      binary = IO.iodata_to_binary([Wire.uint32(7), Wire.bool(false), Wire.string("Banned")])

      assert UploadResponse.decode(binary) ==
               %UploadResponse{token: 7, allowed: false, reason: :banned}
    end

    test "round trips" do
      msg = %UploadResponse{token: 3, allowed: false, reason: :too_many_files}

      assert msg |> UploadResponse.encode() |> IO.iodata_to_binary() |> UploadResponse.decode() ==
               msg
    end
  end
end
