defmodule Soulseek.Server.ResetDistributed do
  @moduledoc false

  defstruct []

  @type t :: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ResetDistributed do
  def encode(%Soulseek.Server.ResetDistributed{}), do: []
end
