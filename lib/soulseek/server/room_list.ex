defmodule Soulseek.Server.RoomList do
  @moduledoc """
  The RoomList message (server code 64).

  The client sends an empty `Request`; the server replies with a `Response`
  listing public rooms, owned private rooms, and other private rooms (each with
  their user counts), plus operated private rooms.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "An empty request for the room list, sent by the client to the server."

    @behaviour Soulseek.Message

    defstruct []

    @type t :: %__MODULE__{}

    @impl true
    def decode(<<>>), do: %__MODULE__{}
  end

  defmodule Response do
    @moduledoc "The server's room list, sent to the client."

    @behaviour Soulseek.Message

    defmodule Room do
      @moduledoc "A room and its user count."

      @enforce_keys [:name, :user_count]
      defstruct [:name, :user_count]

      @type t :: %__MODULE__{name: String.t(), user_count: non_neg_integer()}
    end

    @enforce_keys [:rooms, :owned_private_rooms, :private_rooms, :operated_private_rooms]
    defstruct [:rooms, :owned_private_rooms, :private_rooms, :operated_private_rooms]

    @type t :: %__MODULE__{
            rooms: [Room.t()],
            owned_private_rooms: [Room.t()],
            private_rooms: [Room.t()],
            operated_private_rooms: [String.t()]
          }

    @impl true
    def decode(binary) do
      {rooms, rest} = take_rooms(binary)
      {owned, rest} = take_rooms(rest)
      {private, rest} = take_rooms(rest)
      {operated, <<>>} = Wire.take_array(rest, &Wire.take_string/1)

      %__MODULE__{
        rooms: rooms,
        owned_private_rooms: owned,
        private_rooms: private,
        operated_private_rooms: operated
      }
    end

    defp take_rooms(binary) do
      {names, rest} = Wire.take_array(binary, &Wire.take_string/1)
      {counts, rest} = Wire.take_array(rest, &Wire.take_uint32/1)
      true = length(names) == length(counts)

      rooms =
        Enum.zip_with(names, counts, fn name, count -> %Room{name: name, user_count: count} end)

      {rooms, rest}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomList.Request do
  def encode(%Soulseek.Server.RoomList.Request{}), do: []
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomList.Response do
  alias Soulseek.Server.RoomList.Response.Room
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomList.Response{} = struct),
    do: [
      encode_rooms(struct.rooms),
      encode_rooms(struct.owned_private_rooms),
      encode_rooms(struct.private_rooms),
      Wire.array(struct.operated_private_rooms, &Wire.string/1)
    ]

  defp encode_rooms(rooms),
    do: [
      Wire.array(rooms, fn room -> Wire.string(room.name) end),
      Wire.array(rooms, fn room -> Wire.uint32(room.user_count) end)
    ]
end
