defmodule Soulseek.Server.MessageUser do
  @moduledoc """
  The MessageUser message (server code 22).

  The client sends a `Request` to deliver a private chat message to a user; the
  server delivers a private message to us as a `Response` carrying an ID,
  timestamp, sender, and whether the message is new.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "A private message to send to a user, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:username, :message]
    defstruct [:username, :message]

    @type t :: %__MODULE__{username: String.t(), message: String.t()}

    @impl true
    def encode(%__MODULE__{username: username, message: message}) do
      [Wire.string(username), Wire.string(message)]
    end

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {message, <<>>} = Wire.take_string(rest)
      %__MODULE__{username: username, message: message}
    end
  end

  defmodule Response do
    @moduledoc "A private message delivered to us, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:id, :timestamp, :username, :message, :new_message]
    defstruct [:id, :timestamp, :username, :message, :new_message]

    @type t :: %__MODULE__{
            id: non_neg_integer(),
            timestamp: non_neg_integer(),
            username: String.t(),
            message: String.t(),
            new_message: boolean()
          }

    @impl true
    def encode(%__MODULE__{} = struct) do
      [
        Wire.uint32(struct.id),
        Wire.uint32(struct.timestamp),
        Wire.string(struct.username),
        Wire.string(struct.message),
        Wire.bool(struct.new_message)
      ]
    end

    @impl true
    def decode(binary) do
      {id, rest} = Wire.take_uint32(binary)
      {timestamp, rest} = Wire.take_uint32(rest)
      {username, rest} = Wire.take_string(rest)
      {message, rest} = Wire.take_string(rest)
      {new_message, <<>>} = Wire.take_bool(rest)

      %__MODULE__{
        id: id,
        timestamp: timestamp,
        username: username,
        message: message,
        new_message: new_message
      }
    end
  end
end
