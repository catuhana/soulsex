defmodule Soulseek.Server.RemoveRoomOperator do
  @moduledoc """
  The RemoveRoomOperator message (server code 144).

  The client removes operator abilities from a private room member; the server
  echoes it to room members. Both directions carry room and username.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :username]
  defstruct [:room, :username]

  @type t :: %__MODULE__{room: String.t(), username: String.t()}

  @impl true
  def encode(%__MODULE__{room: room, username: username}),
    do: [Wire.string(room), Wire.string(username)]

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, <<>>} = Wire.take_string(rest)

    %__MODULE__{room: room, username: username}
  end
end
