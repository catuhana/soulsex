defmodule Soulseek.File.Offset do
  @moduledoc """
  The FileOffset message, sent over a file ('F') connection at its start to tell
  the uploading peer how many bytes of the file we have already downloaded. The
  offset is `0` when nothing was downloaded.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:offset]
  defstruct [:offset]

  @type t :: %__MODULE__{offset: non_neg_integer()}

  @impl true
  def decode(binary) do
    {offset, <<>>} = Wire.take_uint64(binary)

    %__MODULE__{offset: offset}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.File.Offset do
  alias Soulseek.Wire

  def encode(%Soulseek.File.Offset{offset: offset}), do: Wire.uint64(offset)
end
