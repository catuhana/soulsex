defmodule Soulseek.Server.ServerPing do
  @moduledoc """
  The ServerPing message (server code 32).

  An empty message the client sends to keep the connection alive. The server no
  longer replies.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def encode(%__MODULE__{}), do: []

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
