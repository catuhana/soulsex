defmodule Soulseek.Server.SetRoomTicker do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :ticker]
  defstruct [:room, :ticker]

  @type t :: %__MODULE__{room: String.t(), ticker: String.t()}

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {ticker, <<>>} = Wire.take_string(rest)

    %__MODULE__{room: room, ticker: ticker}
  end
end
