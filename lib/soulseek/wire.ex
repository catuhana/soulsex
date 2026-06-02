defmodule Soulseek.Wire do
  @moduledoc """
  Encoders and decoders for the Soulseek protocol's primitive data types.

  Every primitive from the protocol's packing format has two halves:

    - an encoder (`uint8/1`, `string/1`, ...) that turns an Elixir term into its
      wire representation, and
    - a `take_*` decoder that reads one value off the front of a binary and
      returns `{value, rest}`, where `rest` is the unconsumed remainder.

  Decoders are meant to be chained: feed the `rest` of one into the next to walk
  through a message field by field.

  Integers are little-endian. See the "Packing" section of the Nicotine+
  protocol documentation for the underlying reference.
  """

  @doc "Encodes an 8-bit unsigned integer as a single byte."
  @spec uint8(integer()) :: binary()
  def uint8(value) when is_integer(value), do: <<value::little-8>>

  @doc "Encodes a 16-bit unsigned integer as 2 little-endian bytes."
  @spec uint16(integer()) :: binary()
  def uint16(value) when is_integer(value), do: <<value::little-16>>

  @doc "Encodes a 32-bit unsigned integer as 4 little-endian bytes."
  @spec uint32(integer()) :: binary()
  def uint32(value) when is_integer(value), do: <<value::little-32>>

  @doc "Encodes a 64-bit unsigned integer as 8 little-endian bytes."
  @spec uint64(integer()) :: binary()
  def uint64(value) when is_integer(value), do: <<value::little-64>>

  @doc "Encodes a signed 32-bit integer as 4 little-endian bytes."
  @spec int32(integer()) :: binary()
  def int32(value) when is_integer(value), do: <<value::little-signed-32>>

  @doc "Encodes a boolean as a single byte."
  @spec bool(boolean()) :: binary()
  def bool(true), do: <<1>>
  def bool(false), do: <<0>>

  @doc "Encodes a boolean as a `uint32`."
  @spec uint32_bool(boolean()) :: binary()
  def uint32_bool(true), do: uint32(1)
  def uint32_bool(false), do: uint32(0)

  @doc "Encodes a string as a `uint32` byte length followed by the raw bytes."
  @spec string(binary()) :: iodata()
  def string(value) when is_binary(value), do: [uint32(byte_size(value)), value]

  @doc "Encodes a byte array as a `uint32` byte length followed by the raw bytes."
  @spec bytes(binary()) :: iodata()
  def bytes(value) when is_binary(value), do: [uint32(byte_size(value)), value]

  @doc """
  Encodes a list as a `uint32` element count followed by each element encoded
  with `encode_fun`..
  """
  @spec array([term()], (term() -> iodata())) :: iodata()
  def array(items, encode_fun) when is_list(items) do
    [uint32(length(items)) | Enum.map(items, encode_fun)]
  end

  @doc "Zlib-compresses `iodata()`."
  @spec compress(iodata()) :: binary()
  def compress(data), do: :zlib.compress(IO.iodata_to_binary(data))

  @doc "Zlib-decompresses a binary."
  @spec decompress(binary()) :: binary()
  def decompress(data) when is_binary(data), do: :zlib.uncompress(data)

  @doc "Decodes an 8-bit unsigned integer, returning `{value, rest}`."
  @spec take_uint8(binary()) :: {non_neg_integer(), binary()}
  def take_uint8(<<value::little-8, rest::binary>>), do: {value, rest}

  @doc "Decodes a 16-bit little-endian unsigned integer, returning `{value, rest}`."
  @spec take_uint16(binary()) :: {non_neg_integer(), binary()}
  def take_uint16(<<value::little-16, rest::binary>>), do: {value, rest}

  @doc "Decodes a 32-bit little-endian unsigned integer, returning `{value, rest}`."
  @spec take_uint32(binary()) :: {non_neg_integer(), binary()}
  def take_uint32(<<value::little-32, rest::binary>>), do: {value, rest}

  @doc "Decodes a 64-bit little-endian unsigned integer, returning `{value, rest}`."
  @spec take_uint64(binary()) :: {non_neg_integer(), binary()}
  def take_uint64(<<value::little-64, rest::binary>>), do: {value, rest}

  @doc "Decodes a signed 32-bit little-endian integer, returning `{value, rest}`."
  @spec take_int32(binary()) :: {integer(), binary()}
  def take_int32(<<value::little-signed-32, rest::binary>>), do: {value, rest}

  @doc "Decodes a boolean from a single byte, returning `{value, rest}`."
  @spec take_bool(binary()) :: {boolean(), binary()}
  def take_bool(<<1, rest::binary>>), do: {true, rest}
  def take_bool(<<0, rest::binary>>), do: {false, rest}

  @doc "Decodes a `uint32`-encoded boolean, returning `{value, rest}`."
  @spec take_uint32_bool(binary()) :: {boolean(), binary()}
  def take_uint32_bool(<<1::little-32, rest::binary>>), do: {true, rest}
  def take_uint32_bool(<<0::little-32, rest::binary>>), do: {false, rest}

  @doc "Decodes a length-prefixed string, returning `{value, rest}`."
  @spec take_string(binary()) :: {binary(), binary()}
  def take_string(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}

  @doc "Decodes a length-prefixed byte array, returning `{value, rest}`."
  @spec take_bytes(binary()) :: {binary(), binary()}
  def take_bytes(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}

  @doc """
  Decodes a `uint32` element count followed by that many elements, each read
  with `take_fun`, returning `{values, rest}`.
  """
  @spec take_array(binary(), (binary() -> {term(), binary()})) :: {[term()], binary()}
  def take_array(<<count::little-32, rest::binary>>, take_fun) do
    Enum.map_reduce(1..count//1, rest, fn _, acc -> take_fun.(acc) end)
  end
end
