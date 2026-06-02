defmodule Soulseek.Server.RemoveThingIHate do
  @moduledoc """
  The RemoveThingIHate message (server code 118).

  The client sends this to remove an item from its hate list. The server sends
  no reply.
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
