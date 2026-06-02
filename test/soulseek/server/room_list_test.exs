defmodule Soulseek.Server.RoomListTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RoomList.{Request, Response}
  alias Soulseek.Server.RoomList.Response.Room
  alias Soulseek.Wire

  test "Request round trips an empty message" do
    assert Request.decode(IO.iodata_to_binary(Request.encode(%Request{}))) == %Request{}
  end

  describe "Response" do
    setup do
      response = %Response{
        rooms: [%Room{name: "jazz", user_count: 10}],
        owned_private_rooms: [%Room{name: "myroom", user_count: 2}],
        private_rooms: [%Room{name: "secret", user_count: 5}],
        operated_private_rooms: ["oproom"]
      }

      binary =
        IO.iodata_to_binary([
          Wire.uint32(1),
          Wire.string("jazz"),
          Wire.uint32(1),
          Wire.uint32(10),
          Wire.uint32(1),
          Wire.string("myroom"),
          Wire.uint32(1),
          Wire.uint32(2),
          Wire.uint32(1),
          Wire.string("secret"),
          Wire.uint32(1),
          Wire.uint32(5),
          Wire.uint32(1),
          Wire.string("oproom")
        ])

      %{response: response, binary: binary}
    end

    test "encodes", %{response: response, binary: binary} do
      assert IO.iodata_to_binary(Response.encode(response)) == binary
    end

    test "decodes", %{response: response, binary: binary} do
      assert Response.decode(binary) == response
    end

    test "round trips all-empty lists" do
      response = %Response{
        rooms: [],
        owned_private_rooms: [],
        private_rooms: [],
        operated_private_rooms: []
      }

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
