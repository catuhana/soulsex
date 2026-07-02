defmodule Soulseek.Server.RoomMembers do
  @moduledoc """
  The RoomMembers message (server code 133).

  The server sends the list of members (excluding the owner) of a private room
  we are in. The client sends no such message.
  """

  @enforce_keys [:room, :members]
  defstruct [:room, :members]

  @type t :: %__MODULE__{room: String.t(), members: [String.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomMembers do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomMembers{room: room, members: members}),
    do: [Wire.string(room), Wire.array(members, &Wire.string/1)]
end
