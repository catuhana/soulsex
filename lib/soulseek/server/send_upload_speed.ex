defmodule Soulseek.Server.SendUploadSpeed do
  @moduledoc """
  The SendUploadSpeed message (server code 121).

  The client sends its upload speed after a finished upload so the server can
  update its speed statistics. The server sends no reply.
  """

  @behaviour Soulseek.Message

  @enforce_keys [:speed]
  defstruct [:speed]

  @type t :: %__MODULE__{speed: non_neg_integer()}

  @impl true
  def decode(<<speed::little-32>>), do: %__MODULE__{speed: speed}
end
