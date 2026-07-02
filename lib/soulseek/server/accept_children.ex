defmodule Soulseek.Server.AcceptChildren do
  @moduledoc """
  The AcceptChildren message (server code 100).

  The client tells the server whether it wants to accept child nodes in the
  distributed network. The server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:accept]
  defstruct [:accept]

  @type t :: %__MODULE__{accept: boolean()}

  @impl true
  def decode(binary) do
    {accept, <<>>} = Wire.take_bool(binary)

    %__MODULE__{accept: accept}
  end
end
