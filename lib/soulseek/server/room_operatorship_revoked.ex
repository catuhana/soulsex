defmodule Soulseek.Server.RoomOperatorshipRevoked do
  @moduledoc """
  The RoomOperatorshipRevoked message (server code 146).

  The server tells us our operator abilities were removed in a private room. The
  client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}

  @impl true
  def encode(%__MODULE__{room: room}), do: Wire.string(room)

  @impl true
  def decode(binary) do
    {room, <<>>} = Wire.take_string(binary)

    %__MODULE__{room: room}
  end
end
