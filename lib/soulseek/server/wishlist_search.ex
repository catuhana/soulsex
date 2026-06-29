defmodule Soulseek.Server.WishlistSearch do
  @moduledoc """
  The WishlistSearch message (server code 103).

  The client sends a wishlist search query (with a tracking token) at each
  interval. The server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:token, :query]
  defstruct [:token, :query]

  @type t :: %__MODULE__{token: non_neg_integer(), query: String.t()}

  @impl true
  def encode(%__MODULE__{token: token, query: query}),
    do: [Wire.uint32(token), Wire.string(query)]

  @impl true
  def decode(binary) do
    {token, rest} = Wire.take_uint32(binary)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{token: token, query: query}
  end
end
