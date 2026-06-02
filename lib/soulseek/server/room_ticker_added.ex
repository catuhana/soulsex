defmodule Soulseek.Server.RoomTickerAdded do
  @moduledoc """
  The RoomTickerAdded message (server code 114).

  The server tells us a ticker was added to a room. The client sends no such
  message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :username, :ticker]
  defstruct [:room, :username, :ticker]

  @type t :: %__MODULE__{room: String.t(), username: String.t(), ticker: String.t()}

  @impl true
  def encode(%__MODULE__{} = struct) do
    [Wire.string(struct.room), Wire.string(struct.username), Wire.string(struct.ticker)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, rest} = Wire.take_string(rest)
    {ticker, <<>>} = Wire.take_string(rest)
    %__MODULE__{room: room, username: username, ticker: ticker}
  end
end
