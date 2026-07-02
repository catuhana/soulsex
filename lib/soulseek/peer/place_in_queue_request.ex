defmodule Soulseek.Peer.PlaceInQueueRequest do
  @moduledoc """
  The PlaceInQueueRequest message (peer code 51).

  Asks a peer for the upload queue placement of a file. Carries only the
  filename, in both directions.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:filename]
  defstruct [:filename]

  @type t :: %__MODULE__{filename: String.t()}

  @impl true
  def decode(binary) do
    {filename, <<>>} = Wire.take_string(binary)

    %__MODULE__{filename: filename}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.PlaceInQueueRequest do
  alias Soulseek.Wire

  def encode(%Soulseek.Peer.PlaceInQueueRequest{filename: filename}),
    do: Wire.string(filename)
end
