defmodule Soulseek.FileAttributeType do
  @moduledoc "File attribute types."

  @typedoc """
  - `:bitrate` - Bitrate in kbps.
  - `:duration` - Duration in seconds.
  - `:vbr` - VBR flag (0 or 1).
  - `:encoder` - Encoder (unused).
  - `:sample_rate` - Sample rate in Hz.
  - `:bit_depth` - Bit depth in bits.
  """
  @type t :: :bitrate | :duration | :vbr | :encoder | :sample_rate | :bit_depth

  @spec to_wire(0..5) :: t
  def to_wire(0), do: :bitrate
  def to_wire(1), do: :duration
  def to_wire(2), do: :vbr
  def to_wire(3), do: :encoder
  def to_wire(4), do: :sample_rate
  def to_wire(5), do: :bit_depth

  @spec from_wire(t) :: 0..5
  def from_wire(:bitrate), do: 0
  def from_wire(:duration), do: 1
  def from_wire(:vbr), do: 2
  def from_wire(:encoder), do: 3
  def from_wire(:sample_rate), do: 4
  def from_wire(:bit_depth), do: 5
end
