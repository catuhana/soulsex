defmodule Soulseek.Server.AddThingIHate do
  @moduledoc """
  The AddThingIHate message (server code 117).

  The client sends this to add an item to its hate list. The server sends no
  reply.
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
