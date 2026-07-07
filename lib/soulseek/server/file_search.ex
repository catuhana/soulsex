defmodule Soulseek.Server.FileSearch do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

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

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

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
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.FileSearch.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.FileSearch.Request{token: token, query: query}),
    do: [Wire.uint32(token), Wire.string(query)]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.FileSearch.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.FileSearch.Response{} = struct),
    do: [Wire.string(struct.username), Wire.uint32(struct.token), Wire.string(struct.query)]
end
