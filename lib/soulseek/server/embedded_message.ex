defmodule Soulseek.Server.EmbeddedMessage do
  @moduledoc """
  The EmbeddedMessage message (server code 93).

  The server sends an embedded distributed message (a distributed code and the
  message bytes) when we are a branch root. The distributed message is the raw
  remaining bytes of the payload with no length prefix. The client sends no such
  message.
  """

  @enforce_keys [:code, :message]
  defstruct [:code, :message]

  @type t :: %__MODULE__{code: non_neg_integer(), message: binary()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.EmbeddedMessage do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.EmbeddedMessage{code: code, message: message}),
    do: [Wire.uint8(code), message]
end
