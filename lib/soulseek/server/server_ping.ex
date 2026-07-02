defmodule Soulseek.Server.ServerPing do
  @moduledoc """
  The ServerPing message (server code 32).

  An empty message the client sends to keep the connection alive. The server no
  longer replies.
  """

  defstruct []

  @type t :: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ServerPing do
  def encode(%Soulseek.Server.ServerPing{}), do: []
end
