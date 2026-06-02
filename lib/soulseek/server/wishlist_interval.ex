defmodule Soulseek.Server.WishlistInterval do
  @moduledoc """
  The WishlistInterval message (server code 104).

  The server tells us the wishlist search interval in seconds. The client sends
  no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:interval]
  defstruct [:interval]

  @type t :: %__MODULE__{interval: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{interval: interval}), do: Wire.uint32(interval)

  @impl true
  def decode(<<interval::little-32>>), do: %__MODULE__{interval: interval}
end
