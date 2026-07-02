defmodule Soulseek.Server.CantCreateRoom do
  @moduledoc """
  The CantCreateRoom message (server code 1003).

  The server tells us a room cannot be created (it only seems to be sent when
  the name matches an existing private room). The client sends no such message.
  """

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.CantCreateRoom do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.CantCreateRoom{room: room}), do: Wire.string(room)
end
