defmodule Soulseek.File.TransferInit do
  @moduledoc """
  The FileTransferInit message, sent over a file ('F') connection to tell a peer
  we want to start uploading a file. The token matches the one from the earlier
  TransferRequest peer message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:token]
  defstruct [:token]

  @type t :: %__MODULE__{token: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{token: token}), do: Wire.uint32(token)

  @impl true
  def decode(binary) do
    {token, <<>>} = Wire.take_uint32(binary)

    %__MODULE__{token: token}
  end
end
