defmodule Soulseek.Server.RoomMembers do
  @moduledoc """
  The RoomMembers message (server code 133).

  The server sends the list of members (excluding the owner) of a private room
  we are in. The client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :members]
  defstruct [:room, :members]

  @type t :: %__MODULE__{room: String.t(), members: [String.t()]}

  @impl true
  def encode(%__MODULE__{room: room, members: members}) do
    [Wire.string(room), Wire.array(members, &Wire.string/1)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {members, <<>>} = Wire.take_array(rest, &Wire.take_string/1)
    %__MODULE__{room: room, members: members}
  end
end
