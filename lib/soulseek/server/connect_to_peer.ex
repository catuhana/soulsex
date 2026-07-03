defmodule Soulseek.Server.ConnectToPeer do
  @moduledoc """
  The ConnectToPeer message (server code 18).

  The client sends a `Request` to ask the server to arrange an indirect
  connection with a user; the server forwards it to that user as a `Response`
  carrying our address so they can connect back.
  """

  alias Soulseek.{ConnectionType, ObfuscationType, Wire}

  defmodule Request do
    @moduledoc "A request to connect to a peer, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:token, :username, :type]
    defstruct [:token, :username, :type]

    @type t :: %__MODULE__{
            token: non_neg_integer(),
            username: String.t(),
            type: ConnectionType.t()
          }

    @impl true
    def decode(binary) do
      {token, rest} = Wire.take_uint32(binary)
      {username, rest} = Wire.take_string(rest)
      {type, <<>>} = Wire.take_string(rest)

      %__MODULE__{token: token, username: username, type: ConnectionType.from_wire(type)}
    end
  end

  defmodule Response do
    @moduledoc "A forwarded peer connection request, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [
      :username,
      :type,
      :ip,
      :port,
      :token,
      :privileged,
      :obfuscation_type,
      :obfuscated_port
    ]
    defstruct [
      :username,
      :type,
      :ip,
      :port,
      :token,
      :privileged,
      :obfuscation_type,
      :obfuscated_port
    ]

    @type t :: %__MODULE__{
            username: String.t(),
            type: ConnectionType.t(),
            ip: non_neg_integer(),
            port: :inet.port_number(),
            token: non_neg_integer(),
            privileged: boolean(),
            obfuscation_type: ObfuscationType.t(),
            obfuscated_port: :inet.port_number()
          }

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {type, rest} = Wire.take_string(rest)
      {ip, rest} = Wire.take_uint32(rest)
      {port, rest} = Wire.take_uint32(rest)
      {token, rest} = Wire.take_uint32(rest)
      {privileged, rest} = Wire.take_bool(rest)
      {obfuscation_type, rest} = Wire.take_uint32(rest)
      {obfuscated_port, <<>>} = Wire.take_uint32(rest)

      %__MODULE__{
        username: username,
        type: ConnectionType.from_wire(type),
        ip: ip,
        port: port,
        token: token,
        privileged: privileged,
        obfuscation_type: ObfuscationType.from_wire(obfuscation_type),
        obfuscated_port: obfuscated_port
      }
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ConnectToPeer.Request do
  alias Soulseek.{ConnectionType, Wire}

  def encode(%Soulseek.Server.ConnectToPeer.Request{} = struct),
    do: [
      Wire.uint32(struct.token),
      Wire.string(struct.username),
      struct.type
      |> ConnectionType.to_wire()
      |> Wire.string()
    ]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ConnectToPeer.Response do
  alias Soulseek.{ConnectionType, ObfuscationType, Wire}

  def encode(%Soulseek.Server.ConnectToPeer.Response{} = struct),
    do: [
      Wire.string(struct.username),
      struct.type
      |> ConnectionType.to_wire()
      |> Wire.string(),
      Wire.uint32(struct.ip),
      Wire.uint32(struct.port),
      Wire.uint32(struct.token),
      Wire.bool(struct.privileged),
      struct.obfuscation_type
      |> ObfuscationType.to_wire()
      |> Wire.uint32(),
      Wire.uint32(struct.obfuscated_port)
    ]
end
