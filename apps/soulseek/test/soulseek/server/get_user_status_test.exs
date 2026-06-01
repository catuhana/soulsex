defmodule Soulseek.Server.GetUserStatusTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.GetUserStatus.{Request, Response}
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
    test "encodes status and privilege" do
      response = %Response{username: "alice", status: :online, privileged: true}

      assert IO.iodata_to_binary(Response.encode(response)) ==
               IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(2), Wire.bool(true)])
    end

    test "decodes status and privilege" do
      binary = IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(1), Wire.bool(false)])

      assert Response.decode(binary) ==
               %Response{username: "alice", status: :away, privileged: false}
    end

    test "raises on trailing bytes" do
      binary = IO.iodata_to_binary([Wire.string("alice"), Wire.uint32(2), Wire.bool(true), "x"])

      assert_raise MatchError, fn -> Response.decode(binary) end
    end

    test "round trips" do
      response = %Response{username: "bob", status: :offline, privileged: false}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
