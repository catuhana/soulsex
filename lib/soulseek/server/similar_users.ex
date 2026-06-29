defmodule Soulseek.Server.SimilarUsers do
  @moduledoc """
  The SimilarUsers message (server code 110).

  The client sends an empty `Request`; the server replies with a `Response`
  listing users with similar interests, each with a rating.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "An empty request for similar users, sent by the client to the server."

    @behaviour Soulseek.Message

    defstruct []

    @type t :: %__MODULE__{}

    @impl true
    def encode(%__MODULE__{}), do: []

    @impl true
    def decode(<<>>), do: %__MODULE__{}
  end

  defmodule User do
    @moduledoc "A similar user and their rating."

    @enforce_keys [:username, :rating]
    defstruct [:username, :rating]

    @type t :: %__MODULE__{username: String.t(), rating: non_neg_integer()}
  end

  defmodule Response do
    @moduledoc "A list of similar users, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:users]
    defstruct [:users]

    @type t :: %__MODULE__{users: [User.t()]}

    @impl true
    def encode(%__MODULE__{users: users}), do: Wire.array(users, &encode_user/1)

    defp encode_user(%User{username: username, rating: rating}),
      do: [Wire.string(username), Wire.uint32(rating)]

    @impl true
    def decode(binary) do
      {users, <<>>} = Wire.take_array(binary, &take_user/1)

      %__MODULE__{users: users}
    end

    defp take_user(binary) do
      {username, rest} = Wire.take_string(binary)
      {rating, rest} = Wire.take_uint32(rest)

      {%User{username: username, rating: rating}, rest}
    end
  end
end
