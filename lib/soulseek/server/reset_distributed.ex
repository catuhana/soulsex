defmodule Soulseek.Server.ResetDistributed do
  @moduledoc """
  The ResetDistributed message (server code 130).

  The server asks us to reset our distributed parent and children. An empty
  message; the client sends no such message.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def encode(%__MODULE__{}), do: []

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
