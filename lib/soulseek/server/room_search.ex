defmodule Soulseek.Server.RoomSearch do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :token, :query]
  defstruct [:room, :token, :query]

  @type t :: %__MODULE__{room: String.t(), token: non_neg_integer(), query: String.t()}

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {token, rest} = Wire.take_uint32(rest)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{room: room, token: token, query: query}
  end
end
