defmodule Soulseek.Server.EnableRoomInvitations do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:enable]
  defstruct [:enable]

  @type t :: %__MODULE__{enable: boolean()}

  def decode(binary) do
    {enable, <<>>} = Wire.take_bool(binary)

    %__MODULE__{enable: enable}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.EnableRoomInvitations do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.EnableRoomInvitations{enable: enable}), do: Wire.bool(enable)
end
