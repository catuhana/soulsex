defmodule Soulseek.Server.CantConnectToPeerTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.CantConnectToPeer.{Request, Response}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes token and username" do
      msg = %Request{token: 12_345, username: "alice"}

      assert IO.iodata_to_binary(Request.encode(msg)) ==
               IO.iodata_to_binary([Wire.uint32(12_345), Wire.string("alice")])
    end

    test "decodes token and username" do
      binary = IO.iodata_to_binary([Wire.uint32(12_345), Wire.string("alice")])

      assert Request.decode(binary) == %Request{token: 12_345, username: "alice"}
    end

    test "round trips" do
      msg = %Request{token: 7, username: "bob"}

      assert msg |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == msg
    end
  end

  describe "Response" do
    test "encodes the token" do
      assert IO.iodata_to_binary(Response.encode(%Response{token: 12_345})) == Wire.uint32(12_345)
    end

    test "decodes the token" do
      assert Response.decode(Wire.uint32(12_345)) == %Response{token: 12_345}
    end

    test "round trips" do
      msg = %Response{token: 7}

      assert msg |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() == msg
    end
  end
end
