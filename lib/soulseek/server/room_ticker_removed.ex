defmodule Soulseek.Server.RoomTickerRemoved do
  @moduledoc """
  The RoomTickerRemoved message (server code 115).

  The server tells us a ticker was removed from a room. The client sends no such
  message.
  """

  @enforce_keys [:room, :username]
  defstruct [:room, :username]

  @type t :: %__MODULE__{room: String.t(), username: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomTickerRemoved do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomTickerRemoved{room: room, username: username}),
    do: [Wire.string(room), Wire.string(username)]
end
