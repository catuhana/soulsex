defmodule Soulseek.Server.UserInterests do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:username]
    defstruct [:username]

    @type t :: %__MODULE__{username: String.t()}

    @impl true
    def decode(binary) do
      {username, <<>>} = Wire.take_string(binary)

      %__MODULE__{username: username}
    end
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:username, :liked, :hated]
    defstruct [:username, :liked, :hated]

    @type t :: %__MODULE__{username: String.t(), liked: [String.t()], hated: [String.t()]}

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {liked, rest} = Wire.take_array(rest, &Wire.take_string/1)
      {hated, <<>>} = Wire.take_array(rest, &Wire.take_string/1)

      %__MODULE__{username: username, liked: liked, hated: hated}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.UserInterests.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.UserInterests.Request{username: username}),
    do: Wire.string(username)
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.UserInterests.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.UserInterests.Response{
        username: username,
        liked: liked,
        hated: hated
      }),
      do: [
        Wire.string(username),
        Wire.array(liked, &Wire.string/1),
        Wire.array(hated, &Wire.string/1)
      ]
end
