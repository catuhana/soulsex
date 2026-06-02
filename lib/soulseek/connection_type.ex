defmodule Soulseek.ConnectionType do
  @moduledoc "Connection types negotiated during peer initialization."

  @typedoc """
  - `:peer` - Peer to peer (`"P"`)
  - `:file` - File transfer (`"F"`)
  - `:distributed` - Distributed network (`"D"`)
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
