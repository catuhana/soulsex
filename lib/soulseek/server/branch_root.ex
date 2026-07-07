defmodule Soulseek.Server.BranchRoot do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:root]
  defstruct [:root]

  @type t :: %__MODULE__{root: String.t()}

  @impl true
  def decode(binary) do
    {root, <<>>} = Wire.take_string(binary)

    %__MODULE__{root: root}
  end
end
