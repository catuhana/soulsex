defmodule Soulseek.Peer.UploadDeniedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.UploadDenied
  alias Soulseek.Wire

  test "encodes filename and reason" do
    msg = %UploadDenied{filename: "a.mp3", reason: :file_not_shared}

    assert IO.iodata_to_binary(UploadDenied.encode(msg)) ==
             IO.iodata_to_binary([Wire.string("a.mp3"), Wire.string("File not shared.")])
  end

  test "decodes filename and reason" do
    binary = IO.iodata_to_binary([Wire.string("a.mp3"), Wire.string("Queued")])

    assert UploadDenied.decode(binary) == %UploadDenied{filename: "a.mp3", reason: :queued}
  end

  test "round trips" do
    msg = %UploadDenied{filename: "b.flac", reason: :too_many_megabytes}

    assert msg |> UploadDenied.encode() |> IO.iodata_to_binary() |> UploadDenied.decode() == msg
  end
end
