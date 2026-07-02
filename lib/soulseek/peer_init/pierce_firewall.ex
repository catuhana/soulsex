defmodule Soulseek.PeerInit.PierceFirewall do
  @moduledoc """
  The PierceFireWall message (peer init code 0).

  Sent in response to an indirect connection request; if it reaches the peer,
  the connection is ready. The token comes from the `ConnectToPeer` server
  message. The same shape is used in both directions.
  """

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
