defmodule Soulseek.Peer.FolderContentsRequest do
  @moduledoc """
  The FolderContentsRequest message (peer code 36).

  Asks a peer for the contents of a single folder. Carries a token and the
  folder path, in both directions.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:token, :folder]
  defstruct [:token, :folder]

  @type t :: %__MODULE__{token: non_neg_integer(), folder: String.t()}

  @impl true
  def decode(binary) do
    {token, rest} = Wire.take_uint32(binary)
    {folder, <<>>} = Wire.take_string(rest)

    %__MODULE__{token: token, folder: folder}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.FolderContentsRequest do
  alias Soulseek.Wire

  def encode(%Soulseek.Peer.FolderContentsRequest{token: token, folder: folder}),
    do: [Wire.uint32(token), Wire.string(folder)]
end
