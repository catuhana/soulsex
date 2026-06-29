defmodule Soulseek.Server.RoomSearch do
  @moduledoc """
  The RoomSearch message (server code 120).

  The client sends this to search files shared by users in a specific room. The
  server forwards it to room users as a `FileSearch` message and sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :token, :query]
  defstruct [:room, :token, :query]

  @type t :: %__MODULE__{room: String.t(), token: non_neg_integer(), query: String.t()}

  @impl true
  def encode(%__MODULE__{} = struct),
    do: [Wire.string(struct.room), Wire.uint32(struct.token), Wire.string(struct.query)]

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {token, rest} = Wire.take_uint32(rest)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{room: room, token: token, query: query}
  end
end
