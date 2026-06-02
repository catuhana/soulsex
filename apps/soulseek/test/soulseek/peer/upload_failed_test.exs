defmodule Soulseek.Peer.UploadFailedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.UploadFailed
  alias Soulseek.Wire

  test "encodes the filename" do
    assert IO.iodata_to_binary(UploadFailed.encode(%UploadFailed{filename: "a.mp3"})) ==
             IO.iodata_to_binary(Wire.string("a.mp3"))
  end

  test "decodes the filename" do
    assert UploadFailed.decode(IO.iodata_to_binary(Wire.string("a.mp3"))) ==
             %UploadFailed{filename: "a.mp3"}
  end

  test "round trips" do
    msg = %UploadFailed{filename: "b.flac"}

    assert msg |> UploadFailed.encode() |> IO.iodata_to_binary() |> UploadFailed.decode() == msg
  end
end
