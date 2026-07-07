defmodule Soulseek.Server.RoomTickerAdded do
  @moduledoc false

  @enforce_keys [:room, :username, :ticker]
  defstruct [:room, :username, :ticker]

  @type t :: %__MODULE__{room: String.t(), username: String.t(), ticker: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomTickerAdded do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomTickerAdded{} = struct),
    do: [Wire.string(struct.room), Wire.string(struct.username), Wire.string(struct.ticker)]
end
