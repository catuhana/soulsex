defmodule Soulseek.Peer.SharedFileListRequestTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.SharedFileListRequest

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(SharedFileListRequest.encode(%SharedFileListRequest{})) == <<>>
  end

  test "decodes an empty binary" do
    assert SharedFileListRequest.decode(<<>>) == %SharedFileListRequest{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> SharedFileListRequest.decode("x") end
  end
end
