defmodule Soulseek.Server.ItemSimilarUsers do
  @moduledoc """
  The ItemSimilarUsers message (server code 112).

  The client sends a `Request` with an item; the server replies with a
  `Response` listing users with similar interests for that item.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "A request for similar users for an item, sent by the client to the server."

    @behaviour Soulseek.Message

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

  defmodule Response do
    @moduledoc "Similar users for an item, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:item, :users]
    defstruct [:item, :users]

    @type t :: %__MODULE__{item: String.t(), users: [String.t()]}

    @impl true
    def encode(%__MODULE__{item: item, users: users}) do
      [Wire.string(item), Wire.array(users, &Wire.string/1)]
    end

    @impl true
    def decode(binary) do
      {item, rest} = Wire.take_string(binary)
      {users, <<>>} = Wire.take_array(rest, &Wire.take_string/1)
      %__MODULE__{item: item, users: users}
    end
  end
end
