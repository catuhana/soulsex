defmodule Soulseek.Server.SendUploadSpeedTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SendUploadSpeed
  alias Soulseek.Wire

  test "encodes the speed" do
    assert IO.iodata_to_binary(SendUploadSpeed.encode(%SendUploadSpeed{speed: 2048})) ==
             Wire.uint32(2048)
  end

  test "decodes the speed" do
    assert SendUploadSpeed.decode(Wire.uint32(2048)) == %SendUploadSpeed{speed: 2048}
  end

  test "round trips" do
    msg = %SendUploadSpeed{speed: 512}

    assert msg
           |> SendUploadSpeed.encode()
           |> IO.iodata_to_binary()
           |> SendUploadSpeed.decode() == msg
  end
end
