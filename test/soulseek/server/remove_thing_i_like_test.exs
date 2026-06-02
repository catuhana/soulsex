defmodule Soulseek.Server.RemoveThingILikeTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.RemoveThingILike
  alias Soulseek.Wire

  test "encodes the item" do
    assert IO.iodata_to_binary(RemoveThingILike.encode(%RemoveThingILike{item: "jazz"})) ==
             IO.iodata_to_binary(Wire.string("jazz"))
  end

  test "decodes the item" do
    assert RemoveThingILike.decode(IO.iodata_to_binary(Wire.string("jazz"))) ==
             %RemoveThingILike{item: "jazz"}
  end

  test "raises on trailing bytes" do
    assert_raise MatchError, fn ->
      RemoveThingILike.decode(IO.iodata_to_binary(Wire.string("jazz")) <> "x")
    end
  end

  test "round trips" do
    msg = %RemoveThingILike{item: "blues"}

    assert msg
           |> RemoveThingILike.encode()
           |> IO.iodata_to_binary()
           |> RemoveThingILike.decode() == msg
  end
end
