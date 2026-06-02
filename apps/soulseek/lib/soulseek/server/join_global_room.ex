defmodule Soulseek.Server.JoinGlobalRoom do
  @moduledoc """
  The JoinGlobalRoom message (server code 150).

  An empty message the client sends to subscribe to the public room feed
  (messages from all public rooms). The server sends no reply.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def encode(%__MODULE__{}), do: []

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
