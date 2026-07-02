defmodule Soulseek.Server.UserLeftRoom do
  @moduledoc """
  The UserLeftRoom message (server code 17).

  The server tells us someone has left a room we're in. The client sends no such
  message.
  """

  @enforce_keys [:room, :username]
  defstruct [:room, :username]

  @type t :: %__MODULE__{room: String.t(), username: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.UserLeftRoom do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.UserLeftRoom{room: room, username: username}),
    do: [Wire.string(room), Wire.string(username)]
end
