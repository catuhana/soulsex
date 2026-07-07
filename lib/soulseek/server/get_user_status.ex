defmodule Soulseek.Server.GetUserStatus do
  @moduledoc false

  alias Soulseek.{UserStatusCode, Wire}

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

    @enforce_keys [:username, :status, :privileged]
    defstruct [:username, :status, :privileged]

    @type t :: %__MODULE__{
            username: String.t(),
            status: UserStatusCode.t(),
            privileged: boolean()
          }

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {status, rest} = Wire.take_uint32(rest)
      {privileged, <<>>} = Wire.take_bool(rest)

      %__MODULE__{
        username: username,
        status: UserStatusCode.from_wire(status),
        privileged: privileged
      }
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GetUserStatus.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.GetUserStatus.Request{username: username}),
    do: Wire.string(username)
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GetUserStatus.Response do
  alias Soulseek.{UserStatusCode, Wire}

  def encode(%Soulseek.Server.GetUserStatus.Response{} = struct),
    do: [
      Wire.string(struct.username),
      struct.status
      |> UserStatusCode.to_wire()
      |> Wire.uint32(),
      Wire.bool(struct.privileged)
    ]
end
