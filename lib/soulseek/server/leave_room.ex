defmodule Soulseek.Server.LeaveRoom do
  @moduledoc false

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

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.LeaveRoom do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.LeaveRoom{room: room}), do: Wire.string(room)
end
