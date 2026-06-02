defmodule Soulseek.Server.SayChatroomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SayChatroom.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes room and message" do
      request = %Request{room: "jazz", message: "hi"}

      assert IO.iodata_to_binary(Request.encode(request)) ==
               IO.iodata_to_binary([Wire.string("jazz"), Wire.string("hi")])
    end

    test "decodes room and message" do
      binary = IO.iodata_to_binary([Wire.string("jazz"), Wire.string("hi")])

      assert Request.decode(binary) == %Request{room: "jazz", message: "hi"}
    end

    test "round trips" do
      request = %Request{room: "jazz", message: "hello there"}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response" do
    test "encodes room, username, and message" do
      response = %Response{room: "jazz", username: "alice", message: "hi"}

      assert IO.iodata_to_binary(Response.encode(response)) ==
               IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hi")])
    end

    test "decodes room, username, and message" do
      binary =
        IO.iodata_to_binary([Wire.string("jazz"), Wire.string("alice"), Wire.string("hi")])

      assert Response.decode(binary) == %Response{room: "jazz", username: "alice", message: "hi"}
    end

    test "raises on trailing bytes" do
      binary =
        IO.iodata_to_binary([
          Wire.string("jazz"),
          Wire.string("alice"),
          Wire.string("hi"),
          "x"
        ])

      assert_raise MatchError, fn -> Response.decode(binary) end
    end

    test "round trips" do
      response = %Response{room: "jazz", username: "bob", message: "yo"}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
