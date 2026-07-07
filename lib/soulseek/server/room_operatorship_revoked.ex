defmodule Soulseek.Server.RoomOperatorshipRevoked do
  @moduledoc false

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomOperatorshipRevoked do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomOperatorshipRevoked{room: room}), do: Wire.string(room)
end
