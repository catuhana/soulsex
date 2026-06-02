defmodule Soulseek.Server.SetStatus do
  @moduledoc """
  The SetStatus message (server code 28).

  The client sends its new status to the server (only away and online are used
  in practice). The server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.{UserStatusCode, Wire}

  @enforce_keys [:status]
  defstruct [:status]

  @type t :: %__MODULE__{status: UserStatusCode.t()}

  @impl true
  def encode(%__MODULE__{status: status}), do: Wire.int32(UserStatusCode.to_wire(status))

  @impl true
  def decode(<<status::little-signed-32>>) do
    %__MODULE__{status: UserStatusCode.from_wire(status)}
  end
end
