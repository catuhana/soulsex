defmodule Soulseek.Server.SimilarUsers do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    defstruct []

    @type t :: %__MODULE__{}

    @impl true
    def decode(<<>>), do: %__MODULE__{}
  end

  defmodule User do
    @moduledoc false

    @enforce_keys [:username, :rating]
    defstruct [:username, :rating]

    @type t :: %__MODULE__{username: String.t(), rating: non_neg_integer()}
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:users]
    defstruct [:users]

    @type t :: %__MODULE__{users: [User.t()]}

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

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.SimilarUsers.Request do
  def encode(%Soulseek.Server.SimilarUsers.Request{}), do: []
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.SimilarUsers.Response do
  alias Soulseek.Server.SimilarUsers.User
  alias Soulseek.Wire

  def encode(%Soulseek.Server.SimilarUsers.Response{users: users}),
    do: Wire.array(users, &encode_user/1)

  defp encode_user(%User{username: username, rating: rating}),
    do: [Wire.string(username), Wire.uint32(rating)]
end
