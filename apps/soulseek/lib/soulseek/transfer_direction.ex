defmodule Soulseek.TransferDirection do
  @moduledoc "The direction of a file transfer relative to the peer."

  @typedoc """
  - `:download` - Download from peer (`0`)
  - `:upload` - Upload to peer (`1`)
  """
  @type t :: :download | :upload

  @spec to_wire(t()) :: 0 | 1
  def to_wire(:download), do: 0
  def to_wire(:upload), do: 1

  @spec from_wire(0 | 1) :: t()
  def from_wire(0), do: :download
  def from_wire(1), do: :upload
end
