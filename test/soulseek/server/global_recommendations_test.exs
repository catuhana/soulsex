defmodule Soulseek.Server.GlobalRecommendationsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.GlobalRecommendations.{Recommendation, Request, Response}
  alias Soulseek.Wire

  test "Request round trips an empty message" do
    assert Request.decode(IO.iodata_to_binary(Request.encode(%Request{}))) == %Request{}
  end

  describe "Response" do
    setup do
      response = %Response{
        recommendations: [%Recommendation{item: "jazz", score: 10}],
        unrecommendations: [%Recommendation{item: "noise", score: -7}]
      }

      binary =
        IO.iodata_to_binary([
          Wire.uint32(1),
          Wire.string("jazz"),
          Wire.int32(10),
          Wire.uint32(1),
          Wire.string("noise"),
          Wire.int32(-7)
        ])

      %{response: response, binary: binary}
    end

    test "encodes", %{response: response, binary: binary} do
      assert IO.iodata_to_binary(Response.encode(response)) == binary
    end

    test "decodes", %{response: response, binary: binary} do
      assert Response.decode(binary) == response
    end

    test "round trips empty lists" do
      response = %Response{recommendations: [], unrecommendations: []}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
