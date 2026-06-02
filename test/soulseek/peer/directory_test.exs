defmodule Soulseek.Peer.DirectoryTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.{Directory, File}
  alias Soulseek.Wire

  setup do
    directory = %Directory{
      name: "Music",
      files: [
        %File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []},
        %File{filename: "b.flac", size: 2, extension: "flac", attributes: []}
      ]
    }

    binary =
      IO.iodata_to_binary([
        Wire.string("Music"),
        Wire.uint32(2),
        File.encode(%File{filename: "a.mp3", size: 1, extension: "mp3", attributes: []}),
        File.encode(%File{filename: "b.flac", size: 2, extension: "flac", attributes: []})
      ])

    %{directory: directory, binary: binary}
  end

  test "encode/1 writes the name and files", %{directory: directory, binary: binary} do
    assert IO.iodata_to_binary(Directory.encode(directory)) == binary
  end

  test "take/1 decodes the directory and returns the rest", %{
    directory: directory,
    binary: binary
  } do
    assert Directory.take(binary <> "rest") == {directory, "rest"}
  end

  test "round trips with no files" do
    directory = %Directory{name: "Empty", files: []}

    assert {^directory, <<>>} = Directory.take(IO.iodata_to_binary(Directory.encode(directory)))
  end
end
