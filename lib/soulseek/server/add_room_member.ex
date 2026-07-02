defmodule Soulseek.Server.AddRoomMember do
  @moduledoc """
  The AddRoomMember message (server code 134).

  The client adds a member to a private room (if owner or operator); the server
  echoes it to room members. Both directions carry room and username.
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

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.AddRoomMember do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.AddRoomMember{room: room, username: username}),
    do: [Wire.string(room), Wire.string(username)]
end
