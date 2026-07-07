defmodule Soulseek.Server.RoomTickers do
  @moduledoc false

  defmodule Ticker do
    @moduledoc false

    @enforce_keys [:username, :ticker]
    defstruct [:username, :ticker]

    @type t :: %__MODULE__{username: String.t(), ticker: String.t()}
  end

  @enforce_keys [:room, :tickers]
  defstruct [:room, :tickers]

  @type t :: %__MODULE__{room: String.t(), tickers: [Ticker.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomTickers do
  alias Soulseek.Wire

  alias Soulseek.Server.RoomTickers.Ticker

  def encode(%Soulseek.Server.RoomTickers{room: room, tickers: tickers}),
    do: [Wire.string(room), Wire.array(tickers, &encode_ticker/1)]

  defp encode_ticker(%Ticker{username: username, ticker: ticker}),
    do: [Wire.string(username), Wire.string(ticker)]
end
