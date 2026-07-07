defmodule Soulseek.Server.BranchLevel do
  @moduledoc false

  @behaviour Soulseek.Message

  @enforce_keys [:level]
  defstruct [:level]

  @type t :: %__MODULE__{level: non_neg_integer()}

  @impl true
  def decode(<<level::little-32>>), do: %__MODULE__{level: level}
end
