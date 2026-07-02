defmodule Soulseek.Server.RemoveThingILike do
  @moduledoc """
  The RemoveThingILike message (server code 52).

  The client sends this to remove an item from its likes list. The server sends
  no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:item]
  defstruct [:item]

  @type t :: %__MODULE__{item: String.t()}

  @impl true
  def decode(binary) do
    {item, <<>>} = Wire.take_string(binary)

    %__MODULE__{item: item}
  end
end
