defmodule Soulseek.Server.CancelRoomMembership do
  @moduledoc """
  The CancelRoomMembership message (server code 136).

  The client cancels its own membership of a private room. The server sends no
  reply.
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
