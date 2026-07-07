defmodule Soulseek.Distributed.Search do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @identifier 0x31

  @enforce_keys [:username, :token, :query]
  defstruct [:username, :token, :query]

  @type t :: %__MODULE__{
          username: String.t(),
          token: non_neg_integer(),
          query: String.t()
        }

  @impl true
  def decode(binary) do
    {@identifier, rest} = Wire.take_uint32(binary)
    {username, rest} = Wire.take_string(rest)
    {token, rest} = Wire.take_uint32(rest)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{username: username, token: token, query: query}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Distributed.Search do
  alias Soulseek.Wire

  @identifier 0x31

  def encode(%Soulseek.Distributed.Search{username: username, token: token, query: query}),
    do: [
      Wire.uint32(@identifier),
      Wire.string(username),
      Wire.uint32(token),
      Wire.string(query)
    ]
end
