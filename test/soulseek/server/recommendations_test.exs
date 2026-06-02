defmodule Soulseek.Server.RecommendationsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.Recommendations.{Recommendation, Request, Response}
  alias Soulseek.Wire

  test "Request round trips an empty message" do
    assert Request.decode(IO.iodata_to_binary(Request.encode(%Request{}))) == %Request{}
  end

  describe "Response" do
    setup do
      response = %Response{
        recommendations: [%Recommendation{item: "jazz", score: 5}],
        unrecommendations: [%Recommendation{item: "noise", score: -3}]
      }

      binary =
        IO.iodata_to_binary([
          Wire.uint32(1),
          Wire.string("jazz"),
          Wire.int32(5),
          Wire.uint32(1),
          Wire.string("noise"),
          Wire.int32(-3)
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
      response = %Response{recommendations: [], unrecommendations: []}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
