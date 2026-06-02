defmodule Soulseek.Server.AddThingILike do
  @moduledoc """
  The AddThingILike message (server code 51).

  The client sends this to add an item to its likes list. The server sends no
  reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:item]
  defstruct [:item]

  @type t :: %__MODULE__{item: String.t()}

  @impl true
  def encode(%__MODULE__{item: item}), do: Wire.string(item)

  @impl true
  def decode(binary) do
    {item, <<>>} = Wire.take_string(binary)
    %__MODULE__{item: item}
  end
end
