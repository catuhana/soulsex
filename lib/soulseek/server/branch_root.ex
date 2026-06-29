defmodule Soulseek.Server.BranchRoot do
  @moduledoc """
  The BranchRoot message (server code 127).

  The client tells the server the username of the root of its branch in the
  distributed network. The server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:root]
  defstruct [:root]

  @type t :: %__MODULE__{root: String.t()}

  @impl true
  def encode(%__MODULE__{root: root}), do: Wire.string(root)

  @impl true
  def decode(binary) do
    {root, <<>>} = Wire.take_string(binary)

    %__MODULE__{root: root}
  end
end
