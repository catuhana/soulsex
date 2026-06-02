defmodule Soulseek.Peer.PlaceInQueueResponse do
  @moduledoc """
  The PlaceInQueueResponse message (peer code 44).

  A peer replies with the upload queue placement of the requested file. Carries
  the filename and its place, in both directions.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:filename, :place]
  defstruct [:filename, :place]

  @type t :: %__MODULE__{filename: String.t(), place: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{filename: filename, place: place}) do
    [Wire.string(filename), Wire.uint32(place)]
  end

  @impl true
  def decode(binary) do
    {filename, rest} = Wire.take_string(binary)
    {place, <<>>} = Wire.take_uint32(rest)
    %__MODULE__{filename: filename, place: place}
  end
end
