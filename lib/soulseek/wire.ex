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

  @spec uint8(integer()) :: binary()
  def uint8(value) when is_integer(value), do: <<value::little-8>>

  @spec uint16(integer()) :: binary()
  def uint16(value) when is_integer(value), do: <<value::little-16>>

  @spec uint32(integer()) :: binary()
  def uint32(value) when is_integer(value), do: <<value::little-32>>

  @spec uint64(integer()) :: binary()
  def uint64(value) when is_integer(value), do: <<value::little-64>>

  @spec int32(integer()) :: binary()
  def int32(value) when is_integer(value), do: <<value::little-signed-32>>

  @spec bool(boolean()) :: binary()
  def bool(true), do: <<1>>
  def bool(false), do: <<0>>

  @spec uint32_bool(boolean()) :: binary()
  def uint32_bool(true), do: uint32(1)
  def uint32_bool(false), do: uint32(0)

  @spec string(binary()) :: iodata()
  def string(value) when is_binary(value), do: [uint32(byte_size(value)), value]

  @spec bytes(binary()) :: iodata()
  def bytes(value) when is_binary(value), do: [uint32(byte_size(value)), value]

  @spec array([term()], (term() -> iodata())) :: iodata()
  def array(items, encode_fun) when is_list(items) do
    [uint32(length(items)) | Enum.map(items, encode_fun)]
  end

  @spec compress(iodata()) :: binary()
  def compress(data), do: :zlib.compress(IO.iodata_to_binary(data))

  @spec decompress(binary()) :: binary()
  def decompress(data) when is_binary(data), do: :zlib.uncompress(data)

  @spec take_uint8(binary()) :: {non_neg_integer(), binary()}
  def take_uint8(<<value::little-8, rest::binary>>), do: {value, rest}

  @spec take_uint16(binary()) :: {non_neg_integer(), binary()}
  def take_uint16(<<value::little-16, rest::binary>>), do: {value, rest}

  @spec take_uint32(binary()) :: {non_neg_integer(), binary()}
  def take_uint32(<<value::little-32, rest::binary>>), do: {value, rest}

  @spec take_uint64(binary()) :: {non_neg_integer(), binary()}
  def take_uint64(<<value::little-64, rest::binary>>), do: {value, rest}

  @spec take_int32(binary()) :: {integer(), binary()}
  def take_int32(<<value::little-signed-32, rest::binary>>), do: {value, rest}

  @spec take_bool(binary()) :: {boolean(), binary()}
  def take_bool(<<1, rest::binary>>), do: {true, rest}
  def take_bool(<<0, rest::binary>>), do: {false, rest}

  @spec take_uint32_bool(binary()) :: {boolean(), binary()}
  def take_uint32_bool(<<1::little-32, rest::binary>>), do: {true, rest}
  def take_uint32_bool(<<0::little-32, rest::binary>>), do: {false, rest}

  @spec take_string(binary()) :: {binary(), binary()}
  def take_string(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}

  @spec take_bytes(binary()) :: {binary(), binary()}
  def take_bytes(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}

  @spec take_array(binary(), (binary() -> {term(), binary()})) :: {[term()], binary()}
  def take_array(<<count::little-32, rest::binary>>, take_fun) do
    Enum.map_reduce(1..count//1, rest, fn _, acc -> take_fun.(acc) end)
  end
end
