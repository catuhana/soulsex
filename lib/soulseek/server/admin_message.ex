defmodule Soulseek.Server.AdminMessage do
  @moduledoc """
  The AdminMessage message (server code 66).

  The server delivers a global message from the server admin. The client sends
  no such message.
  """

  @enforce_keys [:message]
  defstruct [:message]

  @type t :: %__MODULE__{message: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.AdminMessage do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.AdminMessage{message: message}), do: Wire.string(message)
end
