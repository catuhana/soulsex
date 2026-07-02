defmodule Soulseek.Server.MessageAcked do
  @moduledoc """
  The MessageAcked message (server code 23).

  The client sends this to confirm receipt of a private message so the server
  stops resending it. The server sends no reply.
  """

  @behaviour Soulseek.Message

  @enforce_keys [:message_id]
  defstruct [:message_id]

  @type t :: %__MODULE__{message_id: non_neg_integer()}

  @impl true
  def decode(<<message_id::little-32>>), do: %__MODULE__{message_id: message_id}
end
