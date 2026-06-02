defmodule Soulseek.Server.UserLeftRoom do
  @moduledoc """
  The UserLeftRoom message (server code 17).

  The server tells us someone has left a room we're in. The client sends no such
  message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :username]
  defstruct [:room, :username]

  @type t :: %__MODULE__{room: String.t(), username: String.t()}

  @impl true
  def encode(%__MODULE__{room: room, username: username}) do
    [Wire.string(room), Wire.string(username)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, <<>>} = Wire.take_string(rest)
    %__MODULE__{room: room, username: username}
  end
end
