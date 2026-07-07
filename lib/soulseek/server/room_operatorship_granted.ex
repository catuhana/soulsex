defmodule Soulseek.Server.RoomOperatorshipGranted do
  @moduledoc false

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomOperatorshipGranted do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomOperatorshipGranted{room: room}), do: Wire.string(room)
end
