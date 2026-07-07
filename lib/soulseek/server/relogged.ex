defmodule Soulseek.Server.Relogged do
  @moduledoc false

  defstruct []

  @type t :: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Relogged do
  def encode(%Soulseek.Server.Relogged{}), do: []
end
