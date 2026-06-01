defmodule Soulseek.Server.WatchUserTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.WatchUser.{Info, Request, Response}
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

  describe "Response.encode/1" do
    test "encodes a nonexistent user" do
      assert IO.iodata_to_binary(Response.encode(%Response{username: "ghost", info: nil})) ==
               IO.iodata_to_binary([Wire.string("ghost"), Wire.bool(false)])
    end

    test "encodes an offline user without a country code" do
      info = %Info{status: :offline, avg_speed: 0, upload_num: 0, unknown: 0, files: 0, dirs: 0}

      assert IO.iodata_to_binary(Response.encode(%Response{username: "alice", info: info})) ==
               IO.iodata_to_binary([
                 Wire.string("alice"),
                 Wire.bool(true),
                 Wire.uint32(0),
                 Wire.uint32(0),
                 Wire.uint32(0),
                 Wire.uint32(0),
                 Wire.uint32(0),
                 Wire.uint32(0)
               ])
    end

    test "encodes an online user with a country code" do
      info = %Info{
        status: :online,
        avg_speed: 1200,
        upload_num: 42,
        unknown: 0,
        files: 1000,
        dirs: 50,
        country_code: "US"
      }

      assert IO.iodata_to_binary(Response.encode(%Response{username: "alice", info: info})) ==
               IO.iodata_to_binary([
                 Wire.string("alice"),
                 Wire.bool(true),
                 Wire.uint32(2),
                 Wire.uint32(1200),
                 Wire.uint32(42),
                 Wire.uint32(0),
                 Wire.uint32(1000),
                 Wire.uint32(50),
                 Wire.string("US")
               ])
    end
  end

  describe "Response.decode/1" do
    test "decodes a nonexistent user" do
      binary = IO.iodata_to_binary([Wire.string("ghost"), Wire.bool(false)])

      assert Response.decode(binary) == %Response{username: "ghost", info: nil}
    end

    test "decodes an online user with a country code" do
      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.bool(true),
          Wire.uint32(2),
          Wire.uint32(1200),
          Wire.uint32(42),
          Wire.uint32(0),
          Wire.uint32(1000),
          Wire.uint32(50),
          Wire.string("US")
        ])

      assert Response.decode(binary) == %Response{
               username: "alice",
               info: %Info{
                 status: :online,
                 avg_speed: 1200,
                 upload_num: 42,
                 unknown: 0,
                 files: 1000,
                 dirs: 50,
                 country_code: "US"
               }
             }
    end

    test "raises on trailing bytes" do
      binary = IO.iodata_to_binary([Wire.string("ghost"), Wire.bool(false), "extra"])

      assert_raise FunctionClauseError, fn -> Response.decode(binary) end
    end
  end

  describe "Response round trip" do
    test "nonexistent" do
      response = %Response{username: "ghost", info: nil}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end

    test "offline without country" do
      response = %Response{
        username: "alice",
        info: %Info{status: :offline, avg_speed: 0, upload_num: 0, unknown: 0, files: 0, dirs: 0}
      }

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end

    test "online with country" do
      response = %Response{
        username: "alice",
        info: %Info{
          status: :online,
          avg_speed: 1200,
          upload_num: 42,
          unknown: 0,
          files: 1000,
          dirs: 50,
          country_code: "US"
        }
      }

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
