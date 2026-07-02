defmodule Soulseek.Server.RoomOperatorshipRevoked do
  @moduledoc """
  The RoomOperatorshipRevoked message (server code 146).

  The server tells us our operator abilities were removed in a private room. The
  client sends no such message.
  """

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomOperatorshipRevoked do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomOperatorshipRevoked{room: room}), do: Wire.string(room)
end
