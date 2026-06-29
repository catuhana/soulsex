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

  @impl true
  def encode(%__MODULE__{enable: enable}), do: Wire.bool(enable)

  @impl true
  def decode(binary) do
    {enable, <<>>} = Wire.take_bool(binary)

    %__MODULE__{enable: enable}
  end
end
