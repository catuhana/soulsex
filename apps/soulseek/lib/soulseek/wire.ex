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

  @doc """
  Encodes an 8-bit unsigned integer as a single byte.

  Values wider than a byte are truncated to their low 8 bits.
  """
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

  @doc "Encodes a boolean as a single byte, `1` for `true` and `0` for `false`."
  @spec bool(boolean()) :: binary()
  def bool(true), do: <<1>>
  def bool(false), do: <<0>>

  @doc """
  Encodes a string as a `uint32` byte length followed by the raw bytes.

  Returns iodata. Shares its wire format with `bytes/1`; the two differ only in
  intent, with `string/1` carrying textual data.
  """
  @spec string(binary()) :: iodata()
  def string(value) when is_binary(value), do: [uint32(byte_size(value)), value]

  @doc """
  Encodes a byte array as a `uint32` byte length followed by the raw bytes.

  Returns iodata. Shares its wire format with `string/1`; the two differ only in
  intent, with `bytes/1` carrying arbitrary binary data.
  """
  @spec bytes(binary()) :: iodata()
  def bytes(value) when is_binary(value), do: [uint32(byte_size(value)), value]

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

  @doc """
  Decodes a length-prefixed string, returning `{value, rest}`.

  Reads a `uint32` length and then that many bytes. Inverse of `string/1`.
  """
  @spec take_string(binary()) :: {binary(), binary()}
  def take_string(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}

  @doc """
  Decodes a length-prefixed byte array, returning `{value, rest}`.

  Reads a `uint32` length and then that many bytes. Inverse of `bytes/1`.
  """
  @spec take_bytes(binary()) :: {binary(), binary()}
  def take_bytes(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}
end
