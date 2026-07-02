defmodule Soulseek.Server.Relogged do
  @moduledoc """
  The Relogged message (server code 41).

  The server sends this empty message when someone else logs in under our
  nickname, just before disconnecting us. The client sends no such message.
  """

  defstruct []

  @type t :: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Relogged do
  def encode(%Soulseek.Server.Relogged{}), do: []
end
