defmodule Soulseek.Server.WishlistSearch do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:token, :query]
  defstruct [:token, :query]

  @type t :: %__MODULE__{token: non_neg_integer(), query: String.t()}

  @impl true
  def decode(binary) do
    {token, rest} = Wire.take_uint32(binary)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{token: token, query: query}
  end
end
