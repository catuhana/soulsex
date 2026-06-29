defmodule Soulseek.Distributed.Search do
  @moduledoc """
  The DistribSearch message (distributed code 3).

  A search request arriving through the distributed network: the originating
  username, the search token, and the query.

  Each message carries a leading `uint32` identifier that is always the code
  point of ASCII character `1` (`49`); it is written and asserted, so it is not
  stored on the struct, and any other value is rejected.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @identifier 49

  @enforce_keys [:username, :token, :query]
  defstruct [:username, :token, :query]

  @type t :: %__MODULE__{
          username: String.t(),
          token: non_neg_integer(),
          query: String.t()
        }

  @impl true
  def encode(%__MODULE__{} = struct),
    do: [
      Wire.uint32(@identifier),
      Wire.string(struct.username),
      Wire.uint32(struct.token),
      Wire.string(struct.query)
    ]

  @impl true
  def decode(binary) do
    {@identifier, rest} = Wire.take_uint32(binary)
    {username, rest} = Wire.take_string(rest)
    {token, rest} = Wire.take_uint32(rest)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{username: username, token: token, query: query}
  end
end
