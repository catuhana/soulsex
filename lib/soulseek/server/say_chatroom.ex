defmodule Soulseek.Server.SayChatroom do
  @moduledoc """
  The SayChatroom message (server code 13).

  The client sends a `Request` to post a message to a room; the server relays it
  to room members as a `Response` that also carries the author's username.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "A chat message to post to a room, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:room, :message]
    defstruct [:room, :message]

    @type t :: %__MODULE__{room: String.t(), message: String.t()}

    @impl true
    def encode(%__MODULE__{room: room, message: message}) do
      [Wire.string(room), Wire.string(message)]
    end

    @impl true
    def decode(binary) do
      {room, rest} = Wire.take_string(binary)
      {message, <<>>} = Wire.take_string(rest)
      %__MODULE__{room: room, message: message}
    end
  end

  defmodule Response do
    @moduledoc "A chat message posted to a room, sent by the server to the client."

    @behaviour Soulseek.Message

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
end
