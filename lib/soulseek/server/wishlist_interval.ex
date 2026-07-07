defmodule Soulseek.Server.WishlistInterval do
  @moduledoc false

  @enforce_keys [:interval]
  defstruct [:interval]

  @type t :: %__MODULE__{interval: non_neg_integer()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.WishlistInterval do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.WishlistInterval{interval: interval}), do: Wire.uint32(interval)
end
