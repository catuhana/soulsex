defmodule Soulseek.Server.RemoveRoomMember do
  @moduledoc """
  The RemoveRoomMember message (server code 135).

  The client removes a member from a private room (if owner or operator); the
  server echoes it to room members. Both directions carry room and username.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :username]
  defstruct [:room, :username]

  @type t :: %__MODULE__{room: String.t(), username: String.t()}

  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, <<>>} = Wire.take_string(rest)

    %__MODULE__{room: room, username: username}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RemoveRoomMember do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RemoveRoomMember{room: room, username: username}),
    do: [Wire.string(room), Wire.string(username)]
end
