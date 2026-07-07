defmodule Soulseek.Server.ParentMinSpeed do
  @moduledoc false

  @enforce_keys [:speed]
  defstruct [:speed]

  @type t :: %__MODULE__{speed: non_neg_integer()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ParentMinSpeed do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ParentMinSpeed{speed: speed}), do: Wire.uint32(speed)
end
