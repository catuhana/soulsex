defmodule Soulseek.Server.GetPeerAddress do
  @moduledoc """
  The GetPeerAddress message (server code 3).

  The client sends a `Request` with a username; the server replies with a
  `Response` carrying that user's IP address, listening port, and obfuscation
  settings.
  """

  alias Soulseek.{ObfuscationType, Wire}

  defmodule Request do
    @moduledoc "A request for a peer's address, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:username]
    defstruct [:username]

    @type t :: %__MODULE__{
            username: String.t()
          }

    @impl true
    def decode(binary) do
      {username, <<>>} = Wire.take_string(binary)

      %__MODULE__{username: username}
    end
  end

  defmodule Response do
    @moduledoc "A peer's address, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:username, :ip, :port, :obfuscation_type, :obfuscated_port]
    defstruct [:username, :ip, :port, :obfuscation_type, :obfuscated_port]

    @type t :: %__MODULE__{
            username: String.t(),
            ip: non_neg_integer(),
            port: :inet.port_number(),
            obfuscation_type: ObfuscationType.t(),
            obfuscated_port: :inet.port_number()
          }

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {ip, rest} = Wire.take_uint32(rest)
      {port, rest} = Wire.take_uint32(rest)
      {obfuscation_type, rest} = Wire.take_uint32(rest)
      {obfuscated_port, <<>>} = Wire.take_uint16(rest)

      %__MODULE__{
        username: username,
        ip: ip,
        port: port,
        obfuscation_type: ObfuscationType.from_wire(obfuscation_type),
        obfuscated_port: obfuscated_port
      }
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GetPeerAddress.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.GetPeerAddress.Request{username: username}),
    do: Wire.string(username)
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GetPeerAddress.Response do
  alias Soulseek.{ObfuscationType, Wire}

  def encode(%Soulseek.Server.GetPeerAddress.Response{} = struct),
    do: [
      Wire.string(struct.username),
      Wire.uint32(struct.ip),
      Wire.uint32(struct.port),
      struct.obfuscation_type
      |> ObfuscationType.to_wire()
      |> Wire.uint32(),
      Wire.uint16(struct.obfuscated_port)
    ]
end
