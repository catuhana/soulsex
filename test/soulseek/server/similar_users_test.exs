defmodule Soulseek.Server.SimilarUsersTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SimilarUsers.{Request, Response, User}
  alias Soulseek.Wire

  test "Request round trips an empty message" do
    assert Request.decode(IO.iodata_to_binary(Request.encode(%Request{}))) == %Request{}
  end

  describe "Response" do
    setup do
      response = %Response{
        users: [%User{username: "alice", rating: 90}, %User{username: "bob", rating: 50}]
      }

      binary =
        IO.iodata_to_binary([
          Wire.uint32(2),
          Wire.string("alice"),
          Wire.uint32(90),
          Wire.string("bob"),
          Wire.uint32(50)
        ])

      %{response: response, binary: binary}
    end

    test "encodes", %{response: response, binary: binary} do
      assert IO.iodata_to_binary(Response.encode(response)) == binary
    end

    test "decodes", %{response: response, binary: binary} do
      assert Response.decode(binary) == response
    end

    test "round trips an empty list" do
      response = %Response{users: []}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
