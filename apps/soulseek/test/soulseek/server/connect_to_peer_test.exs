defmodule Soulseek.Server.ConnectToPeerTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.ConnectToPeer.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes token, username, and type" do
      request = %Request{token: 12_345, username: "alice", type: :peer}

      assert IO.iodata_to_binary(Request.encode(request)) ==
               IO.iodata_to_binary([
                 Wire.uint32(12_345),
                 Wire.string("alice"),
                 Wire.string("P")
               ])
    end

    test "decodes token, username, and type" do
      binary =
        IO.iodata_to_binary([Wire.uint32(12_345), Wire.string("alice"), Wire.string("F")])

      assert Request.decode(binary) == %Request{token: 12_345, username: "alice", type: :file}
    end

    test "round trips" do
      request = %Request{token: 99, username: "bob", type: :distributed}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    setup do
      response = %Response{
        username: "alice",
        type: :peer,
        ip: 2_130_706_433,
        port: 2234,
        token: 12_345,
        privileged: true,
        obfuscation_type: :none,
        obfuscated_port: 0
      }

      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.string("P"),
          Wire.uint32(2_130_706_433),
          Wire.uint32(2234),
          Wire.uint32(12_345),
          Wire.bool(true),
          Wire.uint32(0),
          Wire.uint32(0)
        ])

      %{response: response, binary: binary}
    end

    test "encodes all fields", %{response: response, binary: binary} do
      assert IO.iodata_to_binary(Response.encode(response)) == binary
    end

    test "decodes all fields", %{response: response, binary: binary} do
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
