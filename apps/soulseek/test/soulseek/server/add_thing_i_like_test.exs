defmodule Soulseek.Server.AddThingILikeTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.AddThingILike
  alias Soulseek.Wire

  test "encodes the item" do
    assert IO.iodata_to_binary(AddThingILike.encode(%AddThingILike{item: "jazz"})) ==
             IO.iodata_to_binary(Wire.string("jazz"))
  end

  test "decodes the item" do
    assert AddThingILike.decode(IO.iodata_to_binary(Wire.string("jazz"))) ==
             %AddThingILike{item: "jazz"}
  end

  test "raises on trailing bytes" do
    assert_raise MatchError, fn ->
      AddThingILike.decode(IO.iodata_to_binary(Wire.string("jazz")) <> "x")
    end
  end

  test "round trips" do
    msg = %AddThingILike{item: "blues"}

    assert msg |> AddThingILike.encode() |> IO.iodata_to_binary() |> AddThingILike.decode() == msg
  end
end
