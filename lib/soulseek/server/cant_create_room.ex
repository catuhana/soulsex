defmodule Soulseek.Server.CantCreateRoom do
  @moduledoc """
  The CantCreateRoom message (server code 1003).

  The server tells us a room cannot be created (it only seems to be sent when
  the name matches an existing private room). The client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}

  @impl true
  def encode(%__MODULE__{room: room}), do: Wire.string(room)

  @impl true
  def decode(binary) do
    {room, <<>>} = Wire.take_string(binary)
    %__MODULE__{room: room}
  end
end
