defmodule Soulseek.Server.FileSearch do
  @moduledoc """
  The FileSearch message (server code 26).

  The client sends a `Request` with a token and query to search the network; the
  server relays searches from other users to us as a `Response` carrying the
  searcher's username, token, and query.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "A file search, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:token, :query]
    defstruct [:token, :query]

    @type t :: %__MODULE__{token: non_neg_integer(), query: String.t()}

    @impl true
    def encode(%__MODULE__{token: token, query: query}) do
      [Wire.uint32(token), Wire.string(query)]
    end

    @impl true
    def decode(binary) do
      {token, rest} = Wire.take_uint32(binary)
      {query, <<>>} = Wire.take_string(rest)
      %__MODULE__{token: token, query: query}
    end
  end

  defmodule Response do
    @moduledoc "A relayed file search from another user, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:username, :token, :query]
    defstruct [:username, :token, :query]

    @type t :: %__MODULE__{username: String.t(), token: non_neg_integer(), query: String.t()}

    @impl true
    def encode(%__MODULE__{} = struct) do
      [Wire.string(struct.username), Wire.uint32(struct.token), Wire.string(struct.query)]
    end

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {token, rest} = Wire.take_uint32(rest)
      {query, <<>>} = Wire.take_string(rest)
      %__MODULE__{username: username, token: token, query: query}
    end
  end
end
