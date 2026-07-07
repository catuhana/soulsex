defmodule Soulseek.Server.HaveNoParent do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:no_parent]
  defstruct [:no_parent]

  @type t :: %__MODULE__{no_parent: boolean()}

  @impl true
  def decode(binary) do
    {no_parent, <<>>} = Wire.take_bool(binary)

    %__MODULE__{no_parent: no_parent}
  end
end
