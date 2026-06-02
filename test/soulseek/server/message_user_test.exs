defmodule Soulseek.Server.MessageUserTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.MessageUser.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes username and message" do
      assert IO.iodata_to_binary(Request.encode(%Request{username: "alice", message: "hi"})) ==
               IO.iodata_to_binary([Wire.string("alice"), Wire.string("hi")])
    end

    test "decodes username and message" do
      binary = IO.iodata_to_binary([Wire.string("alice"), Wire.string("hi")])

      assert Request.decode(binary) == %Request{username: "alice", message: "hi"}
    end

    test "round trips" do
      request = %Request{username: "alice", message: "hello"}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    setup do
      response = %Response{
        id: 99,
        timestamp: 1_700_000_000,
        username: "bob",
        message: "yo",
        new_message: true
      }

      binary =
        IO.iodata_to_binary([
          Wire.uint32(99),
          Wire.uint32(1_700_000_000),
          Wire.string("bob"),
          Wire.string("yo"),
          Wire.bool(true)
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
