defmodule Soulseek.Server.WishlistInterval do
  @moduledoc """
  The WishlistInterval message (server code 104).

  The server tells us the wishlist search interval in seconds. The client sends
  no such message.
  """

  @enforce_keys [:interval]
  defstruct [:interval]

  @type t :: %__MODULE__{interval: non_neg_integer()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.WishlistInterval do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.WishlistInterval{interval: interval}), do: Wire.uint32(interval)
end
