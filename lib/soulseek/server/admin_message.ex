defmodule Soulseek.Server.AdminMessage do
  @moduledoc """
  The AdminMessage message (server code 66).

  The server delivers a global message from the server admin. The client sends
  no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:message]
  defstruct [:message]

  @type t :: %__MODULE__{message: String.t()}

  @impl true
  def encode(%__MODULE__{message: message}), do: Wire.string(message)

  @impl true
  def decode(binary) do
    {message, <<>>} = Wire.take_string(binary)

    %__MODULE__{message: message}
  end
end
