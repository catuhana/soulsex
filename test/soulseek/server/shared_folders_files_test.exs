defmodule Soulseek.Server.SharedFoldersFilesTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SharedFoldersFiles
  alias Soulseek.Wire

  test "encodes dirs and files" do
    msg = %SharedFoldersFiles{dirs: 5, files: 100}

    assert IO.iodata_to_binary(SharedFoldersFiles.encode(msg)) ==
             IO.iodata_to_binary([Wire.uint32(5), Wire.uint32(100)])
  end

  test "decodes dirs and files" do
    binary = IO.iodata_to_binary([Wire.uint32(5), Wire.uint32(100)])

    assert SharedFoldersFiles.decode(binary) == %SharedFoldersFiles{dirs: 5, files: 100}
  end

  test "raises on trailing bytes" do
    binary = IO.iodata_to_binary([Wire.uint32(5), Wire.uint32(100), "x"])

    assert_raise MatchError, fn -> SharedFoldersFiles.decode(binary) end
  end

  test "round trips" do
    msg = %SharedFoldersFiles{dirs: 3, files: 42}

    assert msg
           |> SharedFoldersFiles.encode()
           |> IO.iodata_to_binary()
           |> SharedFoldersFiles.decode() == msg
  end
end
