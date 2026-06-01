defmodule Soulseek.Server.JoinRoomTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.JoinRoom.{Request, Response}
  alias Soulseek.Server.JoinRoom.Response.{Private, User}
  alias Soulseek.Wire

  describe "Request" do
    test "encodes room and private flag" do
      assert IO.iodata_to_binary(Request.encode(%Request{room: "jazz", private: true})) ==
               IO.iodata_to_binary([Wire.string("jazz"), Wire.uint32(1)])
    end

    test "decodes room and private flag" do
      binary = IO.iodata_to_binary([Wire.string("jazz"), Wire.uint32(0)])

      assert Request.decode(binary) == %Request{room: "jazz", private: false}
    end

    test "round trips" do
      request = %Request{room: "jazz", private: true}

      assert request |> Request.encode() |> IO.iodata_to_binary() |> Request.decode() == request
    end
  end

  describe "Response (public room)" do
    setup do
      response = %Response{
        room: "jazz",
        users: [
          %User{
            username: "alice",
            status: :online,
            avg_speed: 100,
            upload_num: 10,
            unknown: 0,
            files: 5,
            dirs: 2,
            slots_full: false,
            country_code: "US"
          },
          %User{
            username: "bob",
            status: :away,
            avg_speed: 200,
            upload_num: 20,
            unknown: 0,
            files: 8,
            dirs: 3,
            slots_full: true,
            country_code: "GB"
          }
        ],
        private: nil
      }

      binary =
        IO.iodata_to_binary([
          Wire.string("jazz"),
          Wire.uint32(2),
          Wire.string("alice"),
          Wire.string("bob"),
          Wire.uint32(2),
          Wire.uint32(2),
          Wire.uint32(1),
          Wire.uint32(2),
          Wire.uint32(100),
          Wire.uint32(10),
          Wire.uint32(0),
          Wire.uint32(5),
          Wire.uint32(2),
          Wire.uint32(200),
          Wire.uint32(20),
          Wire.uint32(0),
          Wire.uint32(8),
          Wire.uint32(3),
          Wire.uint32(2),
          Wire.uint32(0),
          Wire.uint32(1),
          Wire.uint32(2),
          Wire.string("US"),
          Wire.string("GB")
        ])

      %{response: response, binary: binary}
    end

    test "encodes", %{response: response, binary: binary} do
      assert IO.iodata_to_binary(Response.encode(response)) == binary
    end

    test "decodes", %{response: response, binary: binary} do
      assert Response.decode(binary) == response
    end

    test "round trips", %{response: response} do
      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end

    test "decodes an empty room" do
      binary =
        IO.iodata_to_binary([
          Wire.string("empty"),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.uint32(0)
        ])

      assert Response.decode(binary) == %Response{room: "empty", users: [], private: nil}
    end
  end

  describe "Response (private room)" do
    test "decodes owner and operators" do
      binary =
        IO.iodata_to_binary([
          Wire.string("secret"),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.string("alice"),
          Wire.uint32(2),
          Wire.string("bob"),
          Wire.string("carol")
        ])

      assert Response.decode(binary) == %Response{
               room: "secret",
               users: [],
               private: %Private{owner: "alice", operators: ["bob", "carol"]}
             }
    end

    test "round trips with users, owner, and operators" do
      response = %Response{
        room: "secret",
        users: [
          %User{
            username: "alice",
            status: :online,
            avg_speed: 100,
            upload_num: 10,
            unknown: 0,
            files: 5,
            dirs: 2,
            slots_full: false,
            country_code: "US"
          }
        ],
        private: %Private{owner: "alice", operators: ["bob", "carol"]}
      }

      assert response |> Response.encode() |> IO.iodata_to_binary() |> Response.decode() ==
               response
    end
  end
end
