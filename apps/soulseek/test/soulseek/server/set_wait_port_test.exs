defmodule Soulseek.Server.SetWaitPortTest do
  use ExUnit.Case, async: true

  alias Soulseek.Server.SetWaitPort
  alias Soulseek.Server.SetWaitPort.Obfuscation
  alias Soulseek.Wire

  describe "encode/1" do
    test "encodes port without obfuscation" do
      msg = %SetWaitPort{port: 2234}

      assert IO.iodata_to_binary(SetWaitPort.encode(msg)) == Wire.uint32(2234)
    end

    test "encodes port with obfuscation" do
      msg = %SetWaitPort{port: 2234, obfuscation: %Obfuscation{type: :rotated, port: 50_000}}

      assert IO.iodata_to_binary(SetWaitPort.encode(msg)) ==
               IO.iodata_to_binary([
                 Wire.uint32(2234),
                 Wire.uint32(1),
                 Wire.uint32(50_000)
               ])
    end
  end

  describe "decode/1" do
    test "decodes port without obfuscation" do
      binary = Wire.uint32(2234)

      assert SetWaitPort.decode(binary) == %SetWaitPort{port: 2234}
    end

    test "decodes port with obfuscation" do
      binary =
        IO.iodata_to_binary([
          Wire.uint32(2234),
          Wire.uint32(1),
          Wire.uint32(50_000)
        ])

      assert SetWaitPort.decode(binary) == %SetWaitPort{
               port: 2234,
               obfuscation: %Obfuscation{type: :rotated, port: 50_000}
             }
    end

    test "raises on trailing bytes when port only" do
      binary = IO.iodata_to_binary([Wire.uint32(2234), "extra"])

      assert_raise FunctionClauseError, fn -> SetWaitPort.decode(binary) end
    end

    test "raises on trailing bytes with obfuscation" do
      binary =
        IO.iodata_to_binary([
          Wire.uint32(2234),
          Wire.uint32(1),
          Wire.uint32(50_000),
          "extra"
        ])

      assert_raise FunctionClauseError, fn -> SetWaitPort.decode(binary) end
    end
  end

  describe "round trip" do
    test "port only" do
      msg = %SetWaitPort{port: 2234}

      assert msg
             |> SetWaitPort.encode()
             |> IO.iodata_to_binary()
             |> SetWaitPort.decode() == msg
    end

    test "port with obfuscation" do
      msg = %SetWaitPort{port: 2234, obfuscation: %Obfuscation{type: :none, port: 50_000}}

      assert msg
             |> SetWaitPort.encode()
             |> IO.iodata_to_binary()
             |> SetWaitPort.decode() == msg
    end

    test "port with rotated obfuscation" do
      msg = %SetWaitPort{port: 2234, obfuscation: %Obfuscation{type: :rotated, port: 50_000}}

      assert msg
             |> SetWaitPort.encode()
             |> IO.iodata_to_binary()
             |> SetWaitPort.decode() == msg
    end
  end
end
