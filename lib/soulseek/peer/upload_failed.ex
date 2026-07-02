defmodule Soulseek.Peer.UploadFailed do
  @moduledoc """
  The UploadFailed message (peer code 46).

  Sent when a file connection for an active upload closes. Carries only the
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

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.UploadFailed do
  alias Soulseek.Wire

  def encode(%Soulseek.Peer.UploadFailed{filename: filename}), do: Wire.string(filename)
end
