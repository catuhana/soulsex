defmodule Soulseek.Server.UserSearch do
  @moduledoc """
  The UserSearch message (server code 42).

  The client sends this to search a specific user's shares; the server forwards
  it to that user as a `FileSearch` message and sends us no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:username, :token, :query]
  defstruct [:username, :token, :query]

  @type t :: %__MODULE__{username: String.t(), token: non_neg_integer(), query: String.t()}

  @impl true
  def encode(%__MODULE__{} = struct),
    do: [Wire.string(struct.username), Wire.uint32(struct.token), Wire.string(struct.query)]

  @impl true
  def decode(binary) do
    {username, rest} = Wire.take_string(binary)
    {token, rest} = Wire.take_uint32(rest)
    {query, <<>>} = Wire.take_string(rest)

    %__MODULE__{username: username, token: token, query: query}
  end
end
