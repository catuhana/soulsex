defmodule Soulseek.Server.GetPeerAddressTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.GetPeerAddress.{Request, Response}
  alias Soulseek.Wire

  describe "Request.encode/1" do
    test "encodes the username" do
      request = %Request{username: "alice"}

      assert IO.iodata_to_binary(Request.encode(request)) ==
               IO.iodata_to_binary(Wire.string("alice"))
    end
  end

  describe "Request.decode/1" do
    test "decodes a request binary" do
      binary = IO.iodata_to_binary(Wire.string("alice"))

      assert Request.decode(binary) == %Request{username: "alice"}
    end

    test "raises on trailing bytes" do
      binary = IO.iodata_to_binary(Wire.string("alice")) <> "extra"

      assert_raise MatchError, fn -> Request.decode(binary) end
    end
  end

  describe "Request round trip" do
    test "encode |> decode returns the original" do
      request = %Request{username: "bob"}

      assert request
             |> Request.encode()
             |> IO.iodata_to_binary()
             |> Request.decode() == request
    end
  end

  describe "Response.encode/1" do
    test "encodes all fields" do
      response = %Response{
        username: "alice",
        ip: 2_130_706_433,
        port: 2234,
        obfuscation_type: :none,
        obfuscated_port: 0
      }

      assert IO.iodata_to_binary(Response.encode(response)) ==
               IO.iodata_to_binary([
                 Wire.string("alice"),
                 Wire.uint32(2_130_706_433),
                 Wire.uint32(2234),
                 Wire.uint32(0),
                 Wire.uint16(0)
               ])
    end

    test "encodes with rotated obfuscation" do
      response = %Response{
        username: "bob",
        ip: 3_232_235_521,
        port: 50_000,
        obfuscation_type: :rotated,
        obfuscated_port: 50_001
      }

      assert IO.iodata_to_binary(Response.encode(response)) ==
               IO.iodata_to_binary([
                 Wire.string("bob"),
                 Wire.uint32(3_232_235_521),
                 Wire.uint32(50_000),
                 Wire.uint32(1),
                 Wire.uint16(50_001)
               ])
    end
  end

  describe "Response.decode/1" do
    test "decodes a response binary" do
      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.uint32(2_130_706_433),
          Wire.uint32(2234),
          Wire.uint32(0),
          Wire.uint16(0)
        ])

      assert Response.decode(binary) == %Response{
               username: "alice",
               ip: 2_130_706_433,
               port: 2234,
               obfuscation_type: :none,
               obfuscated_port: 0
             }
    end

    test "decodes with rotated obfuscation" do
      binary =
        IO.iodata_to_binary([
          Wire.string("bob"),
          Wire.uint32(3_232_235_521),
          Wire.uint32(50_000),
          Wire.uint32(1),
          Wire.uint16(50_001)
        ])

      assert Response.decode(binary) == %Response{
               username: "bob",
               ip: 3_232_235_521,
               port: 50_000,
               obfuscation_type: :rotated,
               obfuscated_port: 50_001
             }
    end

    test "raises on trailing bytes" do
      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.uint32(2_130_706_433),
          Wire.uint32(2234),
          Wire.uint32(0),
          Wire.uint16(0),
          "extra"
        ])

      assert_raise MatchError, fn -> Response.decode(binary) end
    end

    test "raises on an out-of-range obfuscation type" do
      binary =
        IO.iodata_to_binary([
          Wire.string("alice"),
          Wire.uint32(2_130_706_433),
          Wire.uint32(2234),
          Wire.uint32(2),
          Wire.uint16(0)
        ])

      assert_raise FunctionClauseError, fn -> Response.decode(binary) end
    end
  end

  describe "Response round trip" do
    test "without obfuscation" do
      response = %Response{
        username: "alice",
        ip: 2_130_706_433,
        port: 2234,
        obfuscation_type: :none,
        obfuscated_port: 0
      }

      assert response
             |> Response.encode()
             |> IO.iodata_to_binary()
             |> Response.decode() == response
    end

    test "with rotated obfuscation" do
      response = %Response{
        username: "bob",
        ip: 3_232_235_521,
        port: 50_000,
        obfuscation_type: :rotated,
        obfuscated_port: 50_001
      }

      assert response
             |> Response.encode()
             |> IO.iodata_to_binary()
             |> Response.decode() == response
    end
  end
end
