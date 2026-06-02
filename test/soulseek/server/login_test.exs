defmodule Soulseek.Server.LoginTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.Login.{Failure, Request, Response, Success}
  alias Soulseek.Wire

  describe "Request.encode/1" do
    test "encodes the fields in protocol order" do
      request = %Request{
        username: "user",
        password: "pass",
        version_major: 160,
        hash: "abc123",
        version_minor: 1
      }

      assert IO.iodata_to_binary(Request.encode(request)) ==
               IO.iodata_to_binary([
                 Wire.string("user"),
                 Wire.string("pass"),
                 Wire.uint32(160),
                 Wire.string("abc123"),
                 Wire.uint32(1)
               ])
    end
  end

  describe "Request.decode/1" do
    test "decodes a request binary into a struct" do
      binary =
        IO.iodata_to_binary([
          Wire.string("user"),
          Wire.string("pass"),
          Wire.uint32(160),
          Wire.string("abc123"),
          Wire.uint32(1)
        ])

      assert Request.decode(binary) == %Request{
               username: "user",
               password: "pass",
               version_major: 160,
               hash: "abc123",
               version_minor: 1
             }
    end

    test "raises when trailing bytes remain" do
      binary =
        IO.iodata_to_binary([
          Wire.string("user"),
          Wire.string("pass"),
          Wire.uint32(160),
          Wire.string("abc123"),
          Wire.uint32(1),
          "extra"
        ])

      assert_raise MatchError, fn -> Request.decode(binary) end
    end
  end

  describe "Request round trip" do
    test "encode |> decode returns the original" do
      request = %Request{
        username: "alice",
        password: "secret",
        version_major: 157,
        hash: "0f1e2d",
        version_minor: 3
      }

      assert request
             |> Request.encode()
             |> IO.iodata_to_binary()
             |> Request.decode() == request
    end
  end

  describe "Nicotine+ SLSKPROTOCOL.md \"Sending Login Example\"" do
    @example_request %Request{
      username: "username",
      password: "password",
      version_major: 175,
      hash: "d51c9a7e9353746a6020f9602d452929",
      version_minor: 1
    }

    test "encode/1 produces the example's message payload" do
      <<_length::little-32, _code::little-32, payload::binary>> = example_stream()

      assert @example_request |> Request.encode() |> IO.iodata_to_binary() == payload
    end

    test "decode/1 reads the example's message payload" do
      <<_length::little-32, _code::little-32, payload::binary>> = example_stream()

      assert Request.decode(payload) == @example_request
    end
  end

  describe "Response.encode/1" do
    test "encodes a successful response" do
      success = %Success{
        greet: "Welcome",
        ip_address: 2_130_706_433,
        hash: "deadbeef",
        supporter: true
      }

      assert IO.iodata_to_binary(Response.encode(success)) ==
               IO.iodata_to_binary([
                 Wire.bool(true),
                 Wire.string("Welcome"),
                 Wire.uint32(2_130_706_433),
                 Wire.string("deadbeef"),
                 Wire.bool(true)
               ])
    end

    test "encodes a rejection with its wire reason" do
      assert IO.iodata_to_binary(Response.encode(%Failure{reason: :server_full})) ==
               IO.iodata_to_binary([Wire.bool(false), Wire.string("SVRFULL")])
    end

    test "encodes an invalid-username rejection with its detail" do
      failure = %Failure{reason: :invalid_username, detail: :nick_empty}

      assert IO.iodata_to_binary(Response.encode(failure)) ==
               IO.iodata_to_binary([
                 Wire.bool(false),
                 Wire.string("INVALIDUSERNAME"),
                 Wire.string("Nick empty.")
               ])
    end
  end

  describe "Response.decode/1" do
    test "decodes a successful response" do
      binary =
        IO.iodata_to_binary([
          Wire.bool(true),
          Wire.string("Welcome"),
          Wire.uint32(2_130_706_433),
          Wire.string("deadbeef"),
          Wire.bool(true)
        ])

      assert Response.decode(binary) == %Success{
               greet: "Welcome",
               ip_address: 2_130_706_433,
               hash: "deadbeef",
               supporter: true
             }
    end

    test "decodes a rejection into a failure" do
      binary = IO.iodata_to_binary([Wire.bool(false), Wire.string("SVRFULL")])

      assert Response.decode(binary) == %Failure{reason: :server_full}
    end

    test "decodes an invalid-username rejection with its detail" do
      binary =
        IO.iodata_to_binary([
          Wire.bool(false),
          Wire.string("INVALIDUSERNAME"),
          Wire.string("Nick empty.")
        ])

      assert Response.decode(binary) == %Failure{
               reason: :invalid_username,
               detail: :nick_empty
             }
    end

    test "raises when a successful response has trailing bytes" do
      binary =
        IO.iodata_to_binary([
          Wire.bool(true),
          Wire.string("Welcome"),
          Wire.uint32(2_130_706_433),
          Wire.string("deadbeef"),
          Wire.bool(true),
          "extra"
        ])

      assert_raise MatchError, fn -> Response.decode(binary) end
    end

    test "raises on an unknown success discriminator" do
      assert_raise FunctionClauseError, fn -> Response.decode(<<2, 0>>) end
    end
  end

  describe "Response round trip" do
    test "successful response" do
      success = %Success{
        greet: "Hi there",
        ip_address: 3_232_235_521,
        hash: "cafebabe",
        supporter: false
      }

      assert success
             |> Response.encode()
             |> IO.iodata_to_binary()
             |> Response.decode() == success
    end

    test "rejection" do
      failure = %Failure{reason: :invalid_password}

      assert failure
             |> Response.encode()
             |> IO.iodata_to_binary()
             |> Response.decode() == failure
    end

    test "invalid-username rejection with detail" do
      failure = %Failure{reason: :invalid_username, detail: :nick_too_long}

      assert failure
             |> Response.encode()
             |> IO.iodata_to_binary()
             |> Response.decode() == failure
    end
  end

  # "Message as Hex Stream" from the Nicotine+ protocol doc's "Sending Login Example",
  # including the 4-byte message length and 4-byte message code frame header.
  defp example_stream do
    ("48 00 00 00 01 00 00 00 08 00 00 00 75 73 65 72 6e 61 6d 65 " <>
       "08 00 00 00 70 61 73 73 77 6f 72 64 af 00 00 00 20 00 00 00 " <>
       "64 35 31 63 39 61 37 65 39 33 35 33 37 34 36 61 36 30 32 30 " <>
       "66 39 36 30 32 64 34 35 32 39 32 39 01 00 00 00")
    |> String.replace(" ", "")
    |> Base.decode16!(case: :mixed)
  end
end
