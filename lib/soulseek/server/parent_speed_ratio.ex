defmodule Soulseek.Server.ParentSpeedRatio do
  @moduledoc """
  The ParentSpeedRatio message (server code 84).

  The server sends a speed ratio that determines how many children we can have
  in the distributed network (our upload speed divided by the ratio). The client
  sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:ratio]
  defstruct [:ratio]

  @type t :: %__MODULE__{ratio: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{ratio: ratio}), do: Wire.uint32(ratio)

  @impl true
  def decode(<<ratio::little-32>>), do: %__MODULE__{ratio: ratio}
end
