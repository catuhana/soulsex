defmodule Soulseek.Server.RoomOperatorshipGranted do
  @moduledoc """
  The RoomOperatorshipGranted message (server code 145).

  The server tells us we were given operator abilities in a private room. The
  client sends no such message.
  """

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomOperatorshipGranted do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomOperatorshipGranted{room: room}), do: Wire.string(room)
end
