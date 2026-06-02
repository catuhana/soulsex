defmodule Soulseek.Server.FileSearchTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.FileSearch.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes token and query" do
      assert IO.iodata_to_binary(Request.encode(%Request{token: 7, query: "jazz"})) ==
               IO.iodata_to_binary([Wire.uint32(7), Wire.string("jazz")])
    end

    test "decodes token and query" do
      binary = IO.iodata_to_binary([Wire.uint32(7), Wire.string("jazz")])

      assert Request.decode(binary) == %Request{token: 7, query: "jazz"}
    end

    test "round trips" do
      request = %Request{token: 7, query: "blue note"}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    test "encodes username, token, and query" do
      response = %Response{username: "alice", token: 7, query: "jazz"}

      assert IO.iodata_to_binary(Response.encode(response)) ==
               IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), Wire.string("jazz")])
    end

    test "decodes username, token, and query" do
      binary = IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), Wire.string("jazz")])

      assert Response.decode(binary) == %Response{username: "alice", token: 7, query: "jazz"}
    end

    test "raises on trailing bytes" do
      binary =
        IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(7), Wire.string("jazz"), "x"])

      assert_raise MatchError, fn -> Response.decode(binary) end
    end

    test "round trips" do
      response = %Response{username: "bob", token: 9, query: "soul"}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
