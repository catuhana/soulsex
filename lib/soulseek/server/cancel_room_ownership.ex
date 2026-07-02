defmodule Soulseek.Server.CancelRoomOwnership do
  @moduledoc """
  The CancelRoomOwnership message (server code 137).

  The client stops owning a private room. The server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}

  @impl true
  def decode(binary) do
    {room, <<>>} = Wire.take_string(binary)

    %__MODULE__{room: room}
  end
end
