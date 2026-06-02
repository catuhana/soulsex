defmodule Soulseek.Server.GetUserStatus do
  @moduledoc """
  The GetUserStatus message (server code 7).

  The client sends a `Request` with a username; the server replies with a
  `Response` carrying the user's status and whether they are privileged. The
  server also sends this unprompted when a watched user's status changes.
  """

  alias Soulseek.{UserStatusCode, Wire}

  defmodule Request do
    @moduledoc "A request for a user's status, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:username]
    defstruct [:username]

    @type t :: %__MODULE__{username: String.t()}

    @impl true
    def encode(%__MODULE__{username: username}), do: Wire.string(username)

    @impl true
    def decode(binary) do
      {username, <<>>} = Wire.take_string(binary)
      %__MODULE__{username: username}
    end
  end

  defmodule Response do
    @moduledoc "A user's status, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:username, :status, :privileged]
    defstruct [:username, :status, :privileged]

    @type t :: %__MODULE__{
            username: String.t(),
            status: UserStatusCode.t(),
            privileged: boolean()
          }

    @impl true
    def encode(%__MODULE__{} = struct) do
      [
        Wire.string(struct.username),
        Wire.uint32(UserStatusCode.to_wire(struct.status)),
        Wire.bool(struct.privileged)
      ]
    end

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
