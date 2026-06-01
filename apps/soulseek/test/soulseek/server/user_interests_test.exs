defmodule Soulseek.Server.UserInterestsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.UserInterests.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes the username" do
      assert IO.iodata_to_binary(Request.encode(%Request{username: "alice"})) ==
               IO.iodata_to_binary(Wire.string("alice"))
    end

    test "round trips" do
      request = %Request{username: "bob"}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    setup do
      response = %Response{username: "alice", liked: ["jazz", "blues"], hated: ["noise"]}

      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.uint32(2),
          Wire.string("jazz"),
          Wire.string("blues"),
          Wire.uint32(1),
          Wire.string("noise")
        ])

      %{response: response, binary: binary}
    end

    test "encodes", %{response: response, binary: binary} do
      assert IO.iodata_to_binary(Response.encode(response)) == binary
    end

    test "decodes", %{response: response, binary: binary} do
      assert Response.decode(binary) == response
    end

    test "raises on trailing bytes", %{binary: binary} do
      assert_raise MatchError, fn -> Response.decode(binary <> "x") end
    end

    test "round trips empty lists" do
      response = %Response{username: "bob", liked: [], hated: []}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
