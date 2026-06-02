defmodule Soulseek.Peer.UserInfoRequestTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.UserInfoRequest

  test "encodes to an empty binary" do
    assert IO.iodata_to_binary(UserInfoRequest.encode(%UserInfoRequest{})) == <<>>
  end

  test "decodes an empty binary" do
    assert UserInfoRequest.decode(<<>>) == %UserInfoRequest{}
  end

  test "raises on trailing bytes" do
    assert_raise FunctionClauseError, fn -> UserInfoRequest.decode("x") end
  end
end
