defmodule Soulseek.Server.RoomMembershipRevoked do
  @moduledoc false

  @enforce_keys [:room]
  defstruct [:room]

  @type t :: %__MODULE__{room: String.t()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomMembershipRevoked do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomMembershipRevoked{room: room}), do: Wire.string(room)
end
