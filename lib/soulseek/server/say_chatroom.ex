defmodule Soulseek.Server.SayChatroom do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:room, :message]
    defstruct [:room, :message]

    @type t :: %__MODULE__{room: String.t(), message: String.t()}

    @impl true
    def decode(binary) do
      {room, rest} = Wire.take_string(binary)
      {message, <<>>} = Wire.take_string(rest)

      %__MODULE__{room: room, message: message}
    end
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:room, :username, :message]
    defstruct [:room, :username, :message]

    @type t :: %__MODULE__{room: String.t(), username: String.t(), message: String.t()}

    @impl true
    def decode(binary) do
      {room, rest} = Wire.take_string(binary)
      {username, rest} = Wire.take_string(rest)
      {message, <<>>} = Wire.take_string(rest)

      %__MODULE__{room: room, username: username, message: message}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.SayChatroom.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.SayChatroom.Request{room: room, message: message}),
    do: [Wire.string(room), Wire.string(message)]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.SayChatroom.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.SayChatroom.Response{} = struct),
    do: [Wire.string(struct.room), Wire.string(struct.username), Wire.string(struct.message)]
end
