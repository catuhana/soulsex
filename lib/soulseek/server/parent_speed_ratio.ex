defmodule Soulseek.Server.ParentSpeedRatio do
  @moduledoc """
  The ParentSpeedRatio message (server code 84).

  The server sends a speed ratio that determines how many children we can have
  in the distributed network (our upload speed divided by the ratio). The client
  sends no such message.
  """

  @enforce_keys [:ratio]
  defstruct [:ratio]

  @type t :: %__MODULE__{ratio: non_neg_integer()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ParentSpeedRatio do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ParentSpeedRatio{ratio: ratio}), do: Wire.uint32(ratio)
end
