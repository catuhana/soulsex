defmodule Soulseek.Server.ChangePassword do
  @moduledoc """
  The ChangePassword message (server code 142).

  The client sends a new password; the server echoes the new password back to
  confirm the change. Both directions carry only the password.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:password]
  defstruct [:password]

  @type t :: %__MODULE__{password: String.t()}

  @impl true
  def encode(%__MODULE__{password: password}), do: Wire.string(password)

  @impl true
  def decode(binary) do
    {password, <<>>} = Wire.take_string(binary)
    %__MODULE__{password: password}
  end
end
