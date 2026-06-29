defmodule Soulseek.Server.RoomMembershipGranted do
  @moduledoc """
  The RoomMembershipGranted message (server code 139).

  The server tells us we were added to a private room. The client sends no such
  message.
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
