defmodule Soulseek.Peer.PlaceInQueueResponse do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:filename, :place]
  defstruct [:filename, :place]

  @type t :: %__MODULE__{filename: String.t(), place: non_neg_integer()}

  @impl true
  def decode(binary) do
    {filename, rest} = Wire.take_string(binary)
    {place, <<>>} = Wire.take_uint32(rest)

    %__MODULE__{filename: filename, place: place}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.PlaceInQueueResponse do
  alias Soulseek.Wire

  def encode(%Soulseek.Peer.PlaceInQueueResponse{filename: filename, place: place}),
    do: [Wire.string(filename), Wire.uint32(place)]
end
