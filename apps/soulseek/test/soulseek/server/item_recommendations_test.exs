defmodule Soulseek.Server.ItemRecommendationsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ItemRecommendations.{Recommendation, Request, Response}
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
      response = %Response{
        item: "jazz",
        recommendations: [
          %Recommendation{item: "bebop", score: 8},
          %Recommendation{item: "noise", score: -2}
        ]
      }

      binary =
        IO.iodata_to_binary([
          Wire.string("jazz"),
          Wire.uint32(2),
          Wire.string("bebop"),
          Wire.int32(8),
          Wire.string("noise"),
          Wire.int32(-2)
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
      response = %Response{item: "jazz", recommendations: []}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
