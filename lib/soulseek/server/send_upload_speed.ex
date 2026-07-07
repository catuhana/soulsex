defmodule Soulseek.Server.SendUploadSpeed do
  @moduledoc false

  @behaviour Soulseek.Message

  @enforce_keys [:speed]
  defstruct [:speed]

  @type t :: %__MODULE__{speed: non_neg_integer()}

  @impl true
  def decode(<<speed::little-32>>), do: %__MODULE__{speed: speed}
end
