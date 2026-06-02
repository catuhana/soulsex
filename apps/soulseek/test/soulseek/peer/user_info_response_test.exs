defmodule Soulseek.Peer.UserInfoResponseTest do
  use ExUnit.Case, async: true

  alias Soulseek.Peer.UserInfoResponse
  alias Soulseek.Wire

  describe "with a picture" do
    test "encodes the picture" do
      msg = %UserInfoResponse{
        description: "hi",
        picture: "png",
        total_uploads: 5,
        queue_size: 2,
        slots_free: true
      }

      assert IO.iodata_to_binary(UserInfoResponse.encode(msg)) ==
               IO.iodata_to_binary([
                 Wire.string("hi"),
                 Wire.bool(true),
                 Wire.bytes("png"),
                 Wire.uint32(5),
                 Wire.uint32(2),
                 Wire.bool(true)
               ])
    end

    test "decodes the picture" do
      binary =
        IO.iodata_to_binary([
          Wire.string("hi"),
          Wire.bool(true),
          Wire.bytes("png"),
          Wire.uint32(5),
          Wire.uint32(2),
          Wire.bool(true)
        ])

      assert UserInfoResponse.decode(binary) == %UserInfoResponse{
               description: "hi",
               picture: "png",
               total_uploads: 5,
               queue_size: 2,
               slots_free: true,
               upload_permitted: nil
             }
    end
  end

  describe "without a picture" do
    test "encodes only the has-picture flag" do
      msg = %UserInfoResponse{
        description: "hi",
        total_uploads: 5,
        queue_size: 2,
        slots_free: false
      }

      assert IO.iodata_to_binary(UserInfoResponse.encode(msg)) ==
               IO.iodata_to_binary([
                 Wire.string("hi"),
                 Wire.bool(false),
                 Wire.uint32(5),
                 Wire.uint32(2),
                 Wire.bool(false)
               ])
    end

    test "decodes a nil picture" do
      binary =
        IO.iodata_to_binary([
          Wire.string("hi"),
          Wire.bool(false),
          Wire.uint32(5),
          Wire.uint32(2),
          Wire.bool(false)
        ])

      assert UserInfoResponse.decode(binary) == %UserInfoResponse{
               description: "hi",
               picture: nil,
               total_uploads: 5,
               queue_size: 2,
               slots_free: false,
               upload_permitted: nil
             }
    end
  end

  describe "upload permission" do
    test "encodes the permission when present" do
      msg = %UserInfoResponse{
        description: "hi",
        total_uploads: 0,
        queue_size: 0,
        slots_free: true,
        upload_permitted: :everyone
      }

      assert IO.iodata_to_binary(UserInfoResponse.encode(msg)) ==
               IO.iodata_to_binary([
                 Wire.string("hi"),
                 Wire.bool(false),
                 Wire.uint32(0),
                 Wire.uint32(0),
                 Wire.bool(true),
                 Wire.uint32(1)
               ])
    end

    test "decodes the permission when present" do
      binary =
        IO.iodata_to_binary([
          Wire.string("hi"),
          Wire.bool(false),
          Wire.uint32(0),
          Wire.uint32(0),
          Wire.bool(true),
          Wire.uint32(2)
        ])

      assert UserInfoResponse.decode(binary).upload_permitted == :users_in_list
    end

    test "round trips with a permission" do
      msg = %UserInfoResponse{
        description: "bio",
        picture: "jpg",
        total_uploads: 9,
        queue_size: 1,
        slots_free: true,
        upload_permitted: :permitted_users
      }

      assert msg
             |> UserInfoResponse.encode()
             |> IO.iodata_to_binary()
             |> UserInfoResponse.decode() == msg
    end
  end
end
