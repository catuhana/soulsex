defmodule Soulseek.Server.RoomTickers do
  @moduledoc """
  The RoomTickers message (server code 113).

  The server returns the list of tickers (per-user wall messages) in a room. The
  client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  defmodule Ticker do
    @moduledoc "A user's ticker in a room."

    @enforce_keys [:username, :ticker]
    defstruct [:username, :ticker]

    @type t :: %__MODULE__{username: String.t(), ticker: String.t()}
  end

  @enforce_keys [:room, :tickers]
  defstruct [:room, :tickers]

  @type t :: %__MODULE__{room: String.t(), tickers: [Ticker.t()]}

  @impl true
  def encode(%__MODULE__{room: room, tickers: tickers}) do
    [Wire.string(room), Wire.array(tickers, &encode_ticker/1)]
  end

  defp encode_ticker(%Ticker{username: username, ticker: ticker}) do
    [Wire.string(username), Wire.string(ticker)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {tickers, <<>>} = Wire.take_array(rest, &take_ticker/1)
    %__MODULE__{room: room, tickers: tickers}
  end

  defp take_ticker(binary) do
    {username, rest} = Wire.take_string(binary)
    {ticker, rest} = Wire.take_string(rest)
    {%Ticker{username: username, ticker: ticker}, rest}
  end
end
