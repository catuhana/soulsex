defmodule Soulseek.Wire do
  @moduledoc "Encoders and decoders for the Soulseek data types."

  def uint8(value) when is_integer(value), do: <<value::little-8>>
  def uint16(value) when is_integer(value), do: <<value::little-16>>
  def uint32(value) when is_integer(value), do: <<value::little-32>>
  def uint64(value) when is_integer(value), do: <<value::little-64>>

  def int32(value) when is_integer(value), do: <<value::little-signed-32>>

  def bool(true), do: <<1>>
  def bool(false), do: <<0>>

  @spec string(binary()) :: iodata()
  def string(value) when is_binary(value), do: [uint32(byte_size(value)), value]
  @spec bytes(binary()) :: iodata()
  def bytes(value) when is_binary(value), do: [uint32(byte_size(value)), value]

  def take_uint8(<<value::little-8, rest::binary>>), do: {value, rest}
  def take_uint16(<<value::little-16, rest::binary>>), do: {value, rest}
  def take_uint32(<<value::little-32, rest::binary>>), do: {value, rest}
  def take_uint64(<<value::little-64, rest::binary>>), do: {value, rest}

  def take_int32(<<value::little-signed-32, rest::binary>>), do: {value, rest}

  def take_bool(<<1, rest::binary>>), do: {true, rest}
  def take_bool(<<0, rest::binary>>), do: {false, rest}

  def take_string(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}

  def take_bytes(<<length::little-32, value::binary-size(length), rest::binary>>),
    do: {value, rest}
end
