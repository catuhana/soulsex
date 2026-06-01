defmodule Soulseek.Server.ParentMinSpeed do
  @moduledoc """
  The ParentMinSpeed message (server code 83).

  The server tells us the minimum upload speed required to become a parent in
  the distributed network. The client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:speed]
  defstruct [:speed]

  @type t :: %__MODULE__{speed: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{speed: speed}), do: Wire.uint32(speed)

  @impl true
  def decode(<<speed::little-32>>), do: %__MODULE__{speed: speed}
end
