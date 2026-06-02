defmodule Soulseek.Server.GetUserStatsTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.GetUserStats.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes the username" do
      assert IO.iodata_to_binary(Request.encode(%Request{username: "alice"})) ==
               IO.iodata_to_binary(Wire.string("alice"))
    end

    test "decodes the username" do
      assert Request.decode(IO.iodata_to_binary(Wire.string("alice"))) ==
               %Request{username: "alice"}
    end

    test "round trips" do
      request = %Request{username: "bob"}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    setup do
      response = %Response{
        username: "alice",
        avg_speed: 1200,
        upload_num: 42,
        unknown: 0,
        files: 1000,
        dirs: 50
      }

      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.uint32(1200),
          Wire.uint32(42),
          Wire.uint32(0),
          Wire.uint32(1000),
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

    test "raises on trailing bytes", %{binary: binary} do
      assert_raise MatchError, fn -> Response.decode(binary <> "x") end
    end

    test "round trips", %{response: response} do
      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
