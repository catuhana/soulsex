defmodule Soulseek.Server.JoinGlobalRoom do
  @moduledoc false

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
