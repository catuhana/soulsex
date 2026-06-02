defmodule Soulseek.Peer.FileTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.File
  alias Soulseek.Peer.File.Attribute
  alias Soulseek.Wire

  setup do
    file = %File{
      filename: "song.mp3",
      size: 4_096,
      extension: "mp3",
      attributes: [
        %Attribute{type: :bitrate, value: 320},
        %Attribute{type: :duration, value: 210}
      ]
    }

    binary =
      IO.iodata_to_binary([
        Wire.uint8(1),
        Wire.string("song.mp3"),
        Wire.uint64(4_096),
        Wire.string("mp3"),
        Wire.uint32(2),
        Wire.uint32(0),
        Wire.uint32(320),
        Wire.uint32(1),
        Wire.uint32(210)
      ])

    %{entry: file, binary: binary}
  end

  test "encode/1 writes the entry with its leading code byte", %{entry: file, binary: binary} do
    assert IO.iodata_to_binary(File.encode(file)) == binary
  end

  test "take/1 decodes the entry and returns the rest", %{entry: file, binary: binary} do
    assert File.take(binary <> "rest") == {file, "rest"}
  end

  test "take/1 raises when the code byte is not 1" do
    assert_raise FunctionClauseError, fn -> File.take(<<2, 0, 0, 0, 0>>) end
  end

  test "round trips with no attributes" do
    file = %File{filename: "a.txt", size: 1, extension: "txt", attributes: []}

    assert {^file, <<>>} = File.take(IO.iodata_to_binary(File.encode(file)))
  end
end
