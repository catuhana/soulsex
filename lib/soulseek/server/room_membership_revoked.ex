defmodule Soulseek.Server.RoomMembershipRevoked do
  @moduledoc """
  The RoomMembershipRevoked message (server code 140).

  The server tells us we were removed from a private room. The client sends no
  such message.
  """

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomMembershipRevoked do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomMembershipRevoked{room: room}), do: Wire.string(room)
end
