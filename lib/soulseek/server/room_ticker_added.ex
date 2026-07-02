defmodule Soulseek.Server.RoomTickerAdded do
  @moduledoc """
  The RoomTickerAdded message (server code 114).

  The server tells us a ticker was added to a room. The client sends no such
  message.
  """

  @enforce_keys [:room, :username, :ticker]
  defstruct [:room, :username, :ticker]

  @type t :: %__MODULE__{room: String.t(), username: String.t(), ticker: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomTickerAdded do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomTickerAdded{} = struct),
    do: [Wire.string(struct.room), Wire.string(struct.username), Wire.string(struct.ticker)]
end
