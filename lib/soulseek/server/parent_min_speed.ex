defmodule Soulseek.Server.ParentMinSpeed do
  @moduledoc """
  The ParentMinSpeed message (server code 83).

  The server tells us the minimum upload speed required to become a parent in
  the distributed network. The client sends no such message.
  """

  @enforce_keys [:speed]
  defstruct [:speed]

  @type t :: %__MODULE__{speed: non_neg_integer()}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ParentMinSpeed do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ParentMinSpeed{speed: speed}), do: Wire.uint32(speed)
end
