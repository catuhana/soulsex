defmodule Soulseek.Server.GlobalRoomMessage do
  @moduledoc """
  The GlobalRoomMessage message (server code 152).

  The server sends a message written in the public room feed (every line written
  in every public room). The client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :username, :message]
  defstruct [:room, :username, :message]

  @type t :: %__MODULE__{room: String.t(), username: String.t(), message: String.t()}

  @impl true
  def encode(%__MODULE__{} = struct) do
    [Wire.string(struct.room), Wire.string(struct.username), Wire.string(struct.message)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, rest} = Wire.take_string(rest)
    {message, <<>>} = Wire.take_string(rest)
    %__MODULE__{room: room, username: username, message: message}
  end
end
