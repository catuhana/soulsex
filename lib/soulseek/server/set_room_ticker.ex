defmodule Soulseek.Server.SetRoomTicker do
  @moduledoc """
  The SetRoomTicker message (server code 116).

  The client sets its own ticker in a room (an empty ticker removes it). The
  server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :ticker]
  defstruct [:room, :ticker]

  @type t :: %__MODULE__{room: String.t(), ticker: String.t()}

  @impl true
  def encode(%__MODULE__{room: room, ticker: ticker}),
    do: [Wire.string(room), Wire.string(ticker)]

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {ticker, <<>>} = Wire.take_string(rest)

    %__MODULE__{room: room, ticker: ticker}
  end
end
