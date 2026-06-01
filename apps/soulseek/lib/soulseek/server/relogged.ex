defmodule Soulseek.Server.Relogged do
  @moduledoc """
  The Relogged message (server code 41).

  The server sends this empty message when someone else logs in under our
  nickname, just before disconnecting us. The client sends no such message.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def encode(%__MODULE__{}), do: []

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
