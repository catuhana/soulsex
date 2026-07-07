defmodule Soulseek.Distributed.BranchLevel do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:branch_level]
  defstruct [:branch_level]

  @type t :: %__MODULE__{branch_level: integer()}

  @impl true
  def decode(binary) do
    {branch_level, <<>>} = Wire.take_int32(binary)

    %__MODULE__{branch_level: branch_level}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Distributed.BranchLevel do
  alias Soulseek.Wire

  def encode(%Soulseek.Distributed.BranchLevel{branch_level: branch_level}) do
    Wire.int32(branch_level)
  end
end
