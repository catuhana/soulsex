defmodule Soulseek.Server.ItemSimilarUsersTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ItemSimilarUsers.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes the item" do
      assert IO.iodata_to_binary(Request.encode(%Request{item: "jazz"})) ==
               IO.iodata_to_binary(Wire.string("jazz"))
    end

    test "round trips" do
      request = %Request{item: "blues"}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    setup do
      response = %Response{item: "jazz", users: ["alice", "bob"]}

      binary =
        IO.iodata_to_binary([
          Wire.string("jazz"),
          Wire.uint32(2),
          Wire.string("alice"),
          Wire.string("bob")
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
      response = %Response{item: "jazz", users: []}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
