defmodule Soulseek.File.TransferInitTest do
  use ExUnit.Case, async: true

  alias Soulseek.File.TransferInit
  alias Soulseek.Wire

  test "encodes the token" do
    assert IO.iodata_to_binary(TransferInit.encode(%TransferInit{token: 42})) ==
             IO.iodata_to_binary(Wire.uint32(42))
  end

  test "decodes the token" do
    assert TransferInit.decode(IO.iodata_to_binary(Wire.uint32(42))) == %TransferInit{token: 42}
  end

  test "round trips" do
    msg = %TransferInit{token: 1_000}

    assert msg |> TransferInit.encode() |> IO.iodata_to_binary() |> TransferInit.decode() == msg
  end
end
