defmodule Soulseek.Server.ResetDistributed do
  @moduledoc """
  The ResetDistributed message (server code 130).

  The server asks us to reset our distributed parent and children. An empty
  message; the client sends no such message.
  """

  defstruct []

  @type t :: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ResetDistributed do
  def encode(%Soulseek.Server.ResetDistributed{}), do: []
end
