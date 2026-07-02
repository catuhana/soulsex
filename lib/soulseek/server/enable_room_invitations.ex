defmodule Soulseek.Server.EnableRoomInvitations do
  @moduledoc """
  The EnableRoomInvitations message (server code 141).

  The client enables or disables private room invitations; the server echoes the
  setting back. Both directions carry only the flag.
  """

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
