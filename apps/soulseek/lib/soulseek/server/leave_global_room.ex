defmodule Soulseek.Server.LeaveGlobalRoom do
  @moduledoc """
  The LeaveGlobalRoom message (server code 151).

  An empty message the client sends to stop receiving the public room feed. The
  server sends no reply.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def encode(%__MODULE__{}), do: []

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
