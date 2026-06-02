defmodule Soulseek.Peer.QueueUploadTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.QueueUpload
  alias Soulseek.Wire

  test "encodes the filename" do
    assert IO.iodata_to_binary(QueueUpload.encode(%QueueUpload{filename: "a.mp3"})) ==
             IO.iodata_to_binary(Wire.string("a.mp3"))
  end

  test "decodes the filename" do
    assert QueueUpload.decode(IO.iodata_to_binary(Wire.string("a.mp3"))) ==
             %QueueUpload{filename: "a.mp3"}
  end

  test "round trips" do
    msg = %QueueUpload{filename: "b.flac"}

    assert msg |> QueueUpload.encode() |> IO.iodata_to_binary() |> QueueUpload.decode() == msg
  end
end
