defmodule Soulseek.Distributed.BranchRoot do
  @moduledoc """
  The DistribBranchRoot message (distributed code 5).

  The username of the root of the branch we're in in the distributed network. A
  branch root sends its own username.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:branch_root]
  defstruct [:branch_root]

  @type t :: %__MODULE__{branch_root: String.t()}

  @impl true
  def decode(binary) do
    {branch_root, <<>>} = Wire.take_string(binary)

    %__MODULE__{branch_root: branch_root}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Distributed.BranchRoot do
  alias Soulseek.Wire

  def encode(%Soulseek.Distributed.BranchRoot{branch_root: branch_root}) do
    Wire.string(branch_root)
  end
end
