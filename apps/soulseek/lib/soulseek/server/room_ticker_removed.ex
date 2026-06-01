defmodule Soulseek.Server.RoomTickerRemoved do
  @moduledoc """
  The RoomTickerRemoved message (server code 115).

  The server tells us a ticker was removed from a room. The client sends no such
  message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :username]
  defstruct [:room, :username]

  @type t :: %__MODULE__{room: String.t(), username: String.t()}

  @impl true
  def encode(%__MODULE__{room: room, username: username}) do
    [Wire.string(room), Wire.string(username)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, <<>>} = Wire.take_string(rest)
    %__MODULE__{room: room, username: username}
  end
end
