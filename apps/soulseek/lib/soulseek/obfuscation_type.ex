defmodule Soulseek.ObfuscationType do
  @moduledoc "Types of (port?) obfuscation."

  @typedoc """
  - `:none` - None
  - `:rotated` - Rotated
  """
  @type t :: :none | :rotated

  @spec to_wire(t()) :: 0 | 1
  def to_wire(:none), do: 0
  def to_wire(:rotated), do: 1

  @spec from_wire(0 | 1) :: t()
  def from_wire(0), do: :none
  def from_wire(1), do: :rotated
end
