defmodule Soulseek.Distributed.BranchLevel do
  @moduledoc """
  The DistribBranchLevel message (distributed code 4).

  Our position (nth generation) in our branch of the distributed network. A
  branch root's level is `0`.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:branch_level]
  defstruct [:branch_level]

  @type t :: %__MODULE__{branch_level: integer()}

  @impl true
  def encode(%__MODULE__{branch_level: branch_level}), do: Wire.int32(branch_level)

  @impl true
  def decode(binary) do
    {branch_level, <<>>} = Wire.take_int32(binary)
    %__MODULE__{branch_level: branch_level}
  end
end
