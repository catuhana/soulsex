defmodule Soulseek.Server.MessageAcked do
  @moduledoc false

  @behaviour Soulseek.Message

  @enforce_keys [:message_id]
  defstruct [:message_id]

  @type t :: %__MODULE__{message_id: non_neg_integer()}

  @impl true
  def decode(<<message_id::little-32>>), do: %__MODULE__{message_id: message_id}
end
