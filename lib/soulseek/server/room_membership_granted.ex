defmodule Soulseek.Server.RoomMembershipGranted do
  @moduledoc """
  The RoomMembershipGranted message (server code 139).

  The server tells us we were added to a private room. The client sends no such
  message.
  """

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomMembershipGranted do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomMembershipGranted{room: room}), do: Wire.string(room)
end
