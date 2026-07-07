defmodule Soulseek.Server.EmbeddedMessage do
  @moduledoc false

  @enforce_keys [:code, :message]
  defstruct [:code, :message]

  @type t :: %__MODULE__{code: non_neg_integer(), message: binary()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.EmbeddedMessage do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.EmbeddedMessage{code: code, message: message}),
    do: [Wire.uint8(code), message]
end
