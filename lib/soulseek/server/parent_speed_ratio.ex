defmodule Soulseek.Server.ParentSpeedRatio do
  @moduledoc false

  @enforce_keys [:ratio]
  defstruct [:ratio]

  @type t :: %__MODULE__{ratio: non_neg_integer()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ParentSpeedRatio do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ParentSpeedRatio{ratio: ratio}), do: Wire.uint32(ratio)
end
