defmodule Soulseek.Server.CheckPrivilegesTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.CheckPrivileges.{Request, Response}
  alias Soulseek.Wire

  test "Request round trips an empty message" do
    assert Request.decode(IO.iodata_to_binary(Request.encode(%Request{}))) == %Request{}
  end

  describe "Response" do
    test "encodes the time left" do
      assert IO.iodata_to_binary(Response.encode(%Response{time_left: 3600})) == Wire.uint32(3600)
    end

    test "decodes the time left" do
      assert Response.decode(Wire.uint32(3600)) == %Response{time_left: 3600}
    end

    test "round trips" do
      response = %Response{time_left: 7200}

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
