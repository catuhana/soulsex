defmodule Soulseek.WireTest do
  use ExUnit.Case, async: true

  alias Soulseek.Wire

  describe "uint8/1" do
    test "encodes a single byte" do
      assert Wire.uint8(0) == <<0>>
      assert Wire.uint8(1) == <<1>>
      assert Wire.uint8(255) == <<255>>
    end

    test "encodes to exactly one byte" do
      assert byte_size(Wire.uint8(255)) == 1
    end

    test "truncates values larger than a byte" do
      assert Wire.uint8(256) == <<0>>
      assert Wire.uint8(257) == <<1>>
    end
  end

  describe "uint16/1" do
    test "encodes little-endian" do
      assert Wire.uint16(0) == <<0, 0>>
      assert Wire.uint16(1) == <<1, 0>>
      assert Wire.uint16(0x0102) == <<0x02, 0x01>>
      assert Wire.uint16(65_535) == <<255, 255>>
    end

    test "encodes to exactly two bytes" do
      assert byte_size(Wire.uint16(1)) == 2
    end
  end

  describe "uint32/1" do
    test "encodes little-endian" do
      assert Wire.uint32(0) == <<0, 0, 0, 0>>
      assert Wire.uint32(1) == <<1, 0, 0, 0>>
      assert Wire.uint32(0x01020304) == <<0x04, 0x03, 0x02, 0x01>>
      assert Wire.uint32(4_294_967_295) == <<255, 255, 255, 255>>
    end

    test "encodes to exactly four bytes" do
      assert byte_size(Wire.uint32(1)) == 4
    end
  end

  describe "uint64/1" do
    test "encodes little-endian" do
      assert Wire.uint64(0) == <<0, 0, 0, 0, 0, 0, 0, 0>>
      assert Wire.uint64(1) == <<1, 0, 0, 0, 0, 0, 0, 0>>
      assert Wire.uint64(0x0102030405060708) == <<0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01>>
      assert Wire.uint64(18_446_744_073_709_551_615) == <<255, 255, 255, 255, 255, 255, 255, 255>>
    end

    test "encodes to exactly eight bytes" do
      assert byte_size(Wire.uint64(1)) == 8
    end
  end

  describe "int32/1" do
    test "encodes positive values little-endian" do
      assert Wire.int32(0) == <<0, 0, 0, 0>>
      assert Wire.int32(1) == <<1, 0, 0, 0>>
      assert Wire.int32(2_147_483_647) == <<255, 255, 255, 127>>
    end

    test "encodes negative values as two's complement little-endian" do
      assert Wire.int32(-1) == <<255, 255, 255, 255>>
      assert Wire.int32(-2_147_483_648) == <<0, 0, 0, 128>>
    end

    test "encodes to exactly four bytes" do
      assert byte_size(Wire.int32(-1)) == 4
    end
  end

  describe "bool/1" do
    test "encodes true as 1" do
      assert Wire.bool(true) == <<1>>
    end

    test "encodes false as 0" do
      assert Wire.bool(false) == <<0>>
    end
  end

  describe "string/1" do
    test "prefixes the value with its byte length as a uint32" do
      assert IO.iodata_to_binary(Wire.string("abc")) == <<3, 0, 0, 0, "abc">>
    end

    test "encodes an empty string" do
      assert IO.iodata_to_binary(Wire.string("")) == <<0, 0, 0, 0>>
    end

    test "uses byte length, not codepoint count, for multibyte values" do
      value = "héllo"
      encoded = IO.iodata_to_binary(Wire.string(value))
      assert encoded == <<byte_size(value)::little-32, value::binary>>
      assert <<6, 0, 0, 0, _rest::binary>> = encoded
    end

    test "returns iodata" do
      assert [<<3, 0, 0, 0>>, "abc"] = Wire.string("abc")
    end
  end

  describe "bytes/1" do
    test "prefixes the value with its byte length as a uint32" do
      assert IO.iodata_to_binary(Wire.bytes(<<1, 2, 3>>)) == <<3, 0, 0, 0, 1, 2, 3>>
    end

    test "encodes an empty binary" do
      assert IO.iodata_to_binary(Wire.bytes(<<>>)) == <<0, 0, 0, 0>>
    end

    test "returns iodata" do
      assert [<<3, 0, 0, 0>>, <<1, 2, 3>>] = Wire.bytes(<<1, 2, 3>>)
    end
  end

  describe "take_uint8/1" do
    test "decodes a single byte and returns the rest" do
      assert Wire.take_uint8(<<255, "rest">>) == {255, "rest"}
    end

    test "leaves an empty rest when nothing follows" do
      assert Wire.take_uint8(<<42>>) == {42, <<>>}
    end
  end

  describe "take_uint16/1" do
    test "decodes little-endian and returns the rest" do
      assert Wire.take_uint16(<<0x02, 0x01, "rest">>) == {0x0102, "rest"}
      assert Wire.take_uint16(<<255, 255>>) == {65_535, <<>>}
    end
  end

  describe "take_uint32/1" do
    test "decodes little-endian and returns the rest" do
      assert Wire.take_uint32(<<0x04, 0x03, 0x02, 0x01, "rest">>) == {0x01020304, "rest"}
      assert Wire.take_uint32(<<255, 255, 255, 255>>) == {4_294_967_295, <<>>}
    end
  end

  describe "take_uint64/1" do
    test "decodes little-endian and returns the rest" do
      assert Wire.take_uint64(<<0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01, "rest">>) ==
               {0x0102030405060708, "rest"}

      assert Wire.take_uint64(<<255, 255, 255, 255, 255, 255, 255, 255>>) ==
               {18_446_744_073_709_551_615, <<>>}
    end
  end

  describe "take_int32/1" do
    test "decodes positive values and returns the rest" do
      assert Wire.take_int32(<<255, 255, 255, 127, "rest">>) == {2_147_483_647, "rest"}
    end

    test "decodes negative values" do
      assert Wire.take_int32(<<255, 255, 255, 255>>) == {-1, <<>>}
      assert Wire.take_int32(<<0, 0, 0, 128>>) == {-2_147_483_648, <<>>}
    end
  end

  describe "take_bool/1" do
    test "decodes 1 as true" do
      assert Wire.take_bool(<<1, "rest">>) == {true, "rest"}
    end

    test "decodes 0 as false" do
      assert Wire.take_bool(<<0, "rest">>) == {false, "rest"}
    end

    test "raises on values other than 0 or 1" do
      assert_raise FunctionClauseError, fn -> Wire.take_bool(<<2>>) end
    end
  end

  describe "take_string/1" do
    test "reads the length-prefixed value and returns the rest" do
      assert Wire.take_string(<<3, 0, 0, 0, "abc", "rest">>) == {"abc", "rest"}
    end

    test "decodes an empty string" do
      assert Wire.take_string(<<0, 0, 0, 0, "rest">>) == {"", "rest"}
    end

    test "uses byte length for multibyte values" do
      value = "héllo"
      assert Wire.take_string(<<byte_size(value)::little-32, value::binary, "x">>) == {value, "x"}
    end

    test "raises when fewer bytes are available than the prefix claims" do
      assert_raise FunctionClauseError, fn -> Wire.take_string(<<3, 0, 0, 0, "ab">>) end
    end
  end

  describe "take_bytes/1" do
    test "reads the length-prefixed value and returns the rest" do
      assert Wire.take_bytes(<<3, 0, 0, 0, 1, 2, 3, "rest">>) == {<<1, 2, 3>>, "rest"}
    end

    test "decodes an empty binary" do
      assert Wire.take_bytes(<<0, 0, 0, 0, "rest">>) == {<<>>, "rest"}
    end
  end

  describe "uint32_bool/1" do
    test "encodes true and false as four-byte values" do
      assert Wire.uint32_bool(true) == <<1, 0, 0, 0>>
      assert Wire.uint32_bool(false) == <<0, 0, 0, 0>>
    end
  end

  describe "take_uint32_bool/1" do
    test "decodes 1 as true and 0 as false, returning the rest" do
      assert Wire.take_uint32_bool(<<1, 0, 0, 0, "rest">>) == {true, "rest"}
      assert Wire.take_uint32_bool(<<0, 0, 0, 0, "rest">>) == {false, "rest"}
    end

    test "raises on values other than 0 or 1" do
      assert_raise FunctionClauseError, fn -> Wire.take_uint32_bool(<<2, 0, 0, 0>>) end
    end
  end

  describe "array/2" do
    test "prefixes the elements with their count as a uint32" do
      encoded = IO.iodata_to_binary(Wire.array(["a", "bc"], &Wire.string/1))

      assert encoded == <<2, 0, 0, 0, 1, 0, 0, 0, "a", 2, 0, 0, 0, "bc">>
    end

    test "encodes an empty list as a zero count" do
      assert IO.iodata_to_binary(Wire.array([], &Wire.string/1)) == <<0, 0, 0, 0>>
    end
  end

  describe "take_array/2" do
    test "reads the count and then that many elements, returning the rest" do
      binary = <<2, 0, 0, 0, 1, 0, 0, 0, "a", 2, 0, 0, 0, "bc", "rest">>

      assert Wire.take_array(binary, &Wire.take_string/1) == {["a", "bc"], "rest"}
    end

    test "decodes an empty array" do
      assert Wire.take_array(<<0, 0, 0, 0, "rest">>, &Wire.take_string/1) == {[], "rest"}
    end
  end

  describe "compress/1" do
    test "compresses iodata to the zlib binary" do
      assert Wire.compress(["foo", "bar"]) == :zlib.compress("foobar")
    end
  end

  describe "decompress/1" do
    test "decompresses a zlib binary" do
      assert Wire.decompress(:zlib.compress("foobar")) == "foobar"
    end

    test "round trips with compress/1" do
      assert Wire.decompress(Wire.compress(["hello, ", "world"])) == "hello, world"
    end
  end

  describe "round trips" do
    test "uint8" do
      for value <- [0, 1, 2, 127, 128, 200, 254, 255] do
        assert {^value, <<>>} = Wire.take_uint8(Wire.uint8(value))
      end
    end

    test "uint16" do
      for value <- [0, 1, 255, 256, 1000, 40_000, 65_534, 65_535] do
        assert {^value, <<>>} = Wire.take_uint16(Wire.uint16(value))
      end
    end

    test "uint32" do
      for value <- [0, 1, 255, 65_535, 65_536, 1_000_000, 3_000_000_000, 4_294_967_295] do
        assert {^value, <<>>} = Wire.take_uint32(Wire.uint32(value))
      end
    end

    test "uint64" do
      for value <- [
            0,
            1,
            255,
            4_294_967_295,
            4_294_967_296,
            10_000_000_000,
            18_446_744_073_709_551_615
          ] do
        assert {^value, <<>>} = Wire.take_uint64(Wire.uint64(value))
      end
    end

    test "int32" do
      for value <- [
            -2_147_483_648,
            -1_000_000,
            -12_345,
            -1,
            0,
            1,
            12_345,
            1_000_000,
            2_147_483_647
          ] do
        assert {^value, <<>>} = Wire.take_int32(Wire.int32(value))
      end
    end

    test "bool" do
      for value <- [true, false] do
        assert {^value, <<>>} = Wire.take_bool(Wire.bool(value))
      end
    end

    test "uint32_bool" do
      for value <- [true, false] do
        assert {^value, <<>>} = Wire.take_uint32_bool(Wire.uint32_bool(value))
      end
    end

    test "array" do
      for value <- [[], ["a"], ["a", "bc", "def"]] do
        encoded = IO.iodata_to_binary(Wire.array(value, &Wire.string/1))
        assert {^value, <<>>} = Wire.take_array(encoded, &Wire.take_string/1)
      end
    end

    test "string" do
      for value <- ["", "a", "hello world", "héllo", String.duplicate("x", 1000)] do
        assert {^value, <<>>} =
                 Wire.take_string(IO.iodata_to_binary(Wire.string(value)))
      end
    end

    test "bytes" do
      for value <- [<<>>, <<0>>, <<9, 8, 7>>, :crypto.strong_rand_bytes(256)] do
        assert {^value, <<>>} =
                 Wire.take_bytes(IO.iodata_to_binary(Wire.bytes(value)))
      end
    end

    test "decodes a value followed by trailing bytes, preserving the rest" do
      encoded = [
        Wire.uint8(7),
        Wire.uint32(42),
        Wire.string("name"),
        Wire.bool(true)
      ]

      binary = IO.iodata_to_binary(encoded)

      assert {7, after_u8} = Wire.take_uint8(binary)
      assert {42, after_u32} = Wire.take_uint32(after_u8)
      assert {"name", after_str} = Wire.take_string(after_u32)
      assert {true, <<>>} = Wire.take_bool(after_str)
    end
  end
end
