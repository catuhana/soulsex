defmodule Soulseek.Server.GlobalRoomMessage do
  @moduledoc """
  The GlobalRoomMessage message (server code 152).

  The server sends a message written in the public room feed (every line written
  in every public room). The client sends no such message.
  """

  @enforce_keys [:room, :username, :message]
  defstruct [:room, :username, :message]

  @type t :: %__MODULE__{room: String.t(), username: String.t(), message: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GlobalRoomMessage do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.GlobalRoomMessage{} = struct),
    do: [Wire.string(struct.room), Wire.string(struct.username), Wire.string(struct.message)]
end
