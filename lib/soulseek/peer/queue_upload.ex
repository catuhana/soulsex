defmodule Soulseek.Peer.QueueUpload do
  @moduledoc """
  The QueueUpload message (peer code 43).

  Tells a peer that an upload of the named file should be queued on their end.
  Carries only the filename, in both directions.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:filename]
  defstruct [:filename]

  @type t :: %__MODULE__{filename: String.t()}

  @impl true
  def encode(%__MODULE__{filename: filename}), do: Wire.string(filename)

  @impl true
  def decode(binary) do
    {filename, <<>>} = Wire.take_string(binary)
    %__MODULE__{filename: filename}
  end
end
