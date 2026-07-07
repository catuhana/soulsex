defmodule Soulseek.Peer.QueueUpload do
  @moduledoc false

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

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.QueueUpload do
  alias Soulseek.Wire

  def encode(%Soulseek.Peer.QueueUpload{filename: filename}), do: Wire.string(filename)
end
