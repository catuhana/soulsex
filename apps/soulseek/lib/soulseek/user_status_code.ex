defmodule Soulseek.UserStatusCode do
  @moduledoc "User status codes."

  @typedoc """
  - `:offline` - Offline
  - `:away` - Away
  - `:online` - Online
  """
  @type t :: :offline | :away | :online

  @spec to_wire(t()) :: 0..2
  def to_wire(:offline), do: 0
  def to_wire(:away), do: 1
  def to_wire(:online), do: 2

  @spec from_wire(0..2) :: t()
  def from_wire(0), do: :offline
  def from_wire(1), do: :away
  def from_wire(2), do: :online
end
