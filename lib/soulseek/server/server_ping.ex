defmodule Soulseek.Server.ServerPing do
  @moduledoc false

  defstruct []

  @type t :: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ServerPing do
  def encode(%Soulseek.Server.ServerPing{}), do: []
end
