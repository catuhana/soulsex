defmodule Soulseek.Server.ItemSimilarUsers do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:item]
    defstruct [:item]

    @type t :: %__MODULE__{item: String.t()}

    @impl true
    def decode(binary) do
      {item, <<>>} = Wire.take_string(binary)

      %__MODULE__{item: item}
    end
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:item, :users]
    defstruct [:item, :users]

    @type t :: %__MODULE__{item: String.t(), users: [String.t()]}

    @impl true
    def decode(binary) do
      {item, rest} = Wire.take_string(binary)
      {users, <<>>} = Wire.take_array(rest, &Wire.take_string/1)

      %__MODULE__{item: item, users: users}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ItemSimilarUsers.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ItemSimilarUsers.Request{item: item}), do: Wire.string(item)
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ItemSimilarUsers.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ItemSimilarUsers.Response{item: item, users: users}),
    do: [Wire.string(item), Wire.array(users, &Wire.string/1)]
end
