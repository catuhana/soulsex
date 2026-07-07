defmodule Soulseek.Server.UserSearch do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:username, :token, :query]
  defstruct [:username, :token, :query]

  @type t :: %__MODULE__{username: String.t(), token: non_neg_integer(), query: String.t()}

  @impl true
  def decode(binary) do
    {username, rest} = Wire.take_string(binary)
    {token, rest} = Wire.take_uint32(rest)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{username: username, token: token, query: query}
  end
end
