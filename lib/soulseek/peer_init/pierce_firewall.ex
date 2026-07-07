defmodule Soulseek.PeerInit.PierceFirewall do
  @moduledoc false

  @behaviour Soulseek.Message

  @enforce_keys [:token]
  defstruct [:token]

  @type t :: %__MODULE__{token: non_neg_integer()}

  @impl true
  def decode(<<token::little-32>>), do: %__MODULE__{token: token}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.PeerInit.PierceFirewall do
  alias Soulseek.Wire

  def encode(%Soulseek.PeerInit.PierceFirewall{token: token}), do: Wire.uint32(token)
end
