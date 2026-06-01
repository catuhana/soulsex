defmodule Soulseek.Server.BranchLevel do
  @moduledoc """
  The BranchLevel message (server code 126).

  The client tells the server its position (nth generation) in its branch of the
  distributed network. The server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:level]
  defstruct [:level]

  @type t :: %__MODULE__{level: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{level: level}), do: Wire.uint32(level)

  @impl true
  def decode(<<level::little-32>>), do: %__MODULE__{level: level}
end
