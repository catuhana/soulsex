defmodule Soulseek.ConnectionType do
  @moduledoc "Types of connections."

  @typedoc """
  - `:peer` - Peer to Peer
  - `:file` - File Transfer
  - `:distributed` - Distributed Network
  """
  @type t :: :peer | :file | :distributed

  @spec to_wire(t()) :: String.t()
  def to_wire(:peer), do: "P"
  def to_wire(:file), do: "F"
  def to_wire(:distributed), do: "D"

  @spec from_wire(String.t()) :: t()
  def from_wire("P"), do: :peer
  def from_wire("F"), do: :file
  def from_wire("D"), do: :distributed
end
