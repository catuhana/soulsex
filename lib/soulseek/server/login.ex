defmodule Soulseek.Server.Login do
  @moduledoc """
  The Login message (server code 1).

  The client sends a `Request` right after the connection is established; the
  server replies with a `Response`.
  """

  alias Soulseek.{LoginRejectionDetail, LoginRejectionReason, Wire}

  defmodule Request do
    @moduledoc "Login credentials sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:username, :password, :version_major, :hash, :version_minor]
    defstruct [:username, :password, :version_major, :hash, :version_minor]

    @type t :: %__MODULE__{
            username: String.t(),
            password: String.t(),
            version_major: non_neg_integer(),
            hash: String.t(),
            version_minor: non_neg_integer()
          }

    @impl true
    def encode(%__MODULE__{} = struct) do
      [
        Wire.string(struct.username),
        Wire.string(struct.password),
        Wire.uint32(struct.version_major),
        Wire.string(struct.hash),
        Wire.uint32(struct.version_minor)
      ]
    end

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {password, rest} = Wire.take_string(rest)
      {version_major, rest} = Wire.take_uint32(rest)
      {hash, rest} = Wire.take_string(rest)
      {version_minor, <<>>} = Wire.take_uint32(rest)

      %__MODULE__{
        username: username,
        password: password,
        version_major: version_major,
        hash: hash,
        version_minor: version_minor
      }
    end
  end

  defmodule Success do
    @moduledoc "Payload of a successful login `Response`."

    @enforce_keys [:greet, :ip_address, :hash, :supporter]
    defstruct [:greet, :ip_address, :hash, :supporter]

    @type t :: %__MODULE__{
            greet: String.t(),
            ip_address: non_neg_integer(),
            hash: String.t(),
            supporter: boolean()
          }
  end

  defmodule Failure do
    @moduledoc "Payload of a rejected login `Response`."

    @enforce_keys [:reason]
    defstruct [:reason, :detail]

    @type t :: %__MODULE__{
            reason: LoginRejectionReason.t(),
            detail: LoginRejectionDetail.t() | nil
          }
  end

  defmodule Response do
    @moduledoc "The server's reply to a login `Request`: a `Success` or a `Failure`."

    @behaviour Soulseek.Message

    @type t :: Success.t() | Failure.t()

    @impl true
    def encode(%Success{} = success) do
      [
        Wire.bool(true),
        Wire.string(success.greet),
        Wire.uint32(success.ip_address),
        Wire.string(success.hash),
        Wire.bool(success.supporter)
      ]
    end

    def encode(%Failure{reason: :invalid_username, detail: detail}) do
      [
        Wire.bool(false),
        :invalid_username |> LoginRejectionReason.to_wire() |> Wire.string(),
        detail |> LoginRejectionDetail.to_wire() |> Wire.string()
      ]
    end

    def encode(%Failure{reason: reason}) do
      [
        Wire.bool(false),
        reason |> LoginRejectionReason.to_wire() |> Wire.string()
      ]
    end

    @impl true
    def decode(<<1, rest::binary>>) do
      {greet, rest} = Wire.take_string(rest)
      {ip_address, rest} = Wire.take_uint32(rest)
      {hash, rest} = Wire.take_string(rest)
      {supporter, <<>>} = Wire.take_bool(rest)

      %Success{
        greet: greet,
        ip_address: ip_address,
        hash: hash,
        supporter: supporter
      }
    end

    def decode(<<0, rest::binary>>) do
      {reason, rest} = Wire.take_string(rest)
      decode_failure(reason, rest)
    end

    defp decode_failure("INVALIDUSERNAME", rest) do
      {detail, <<>>} = Wire.take_string(rest)

      %Failure{
        reason: LoginRejectionReason.from_wire("INVALIDUSERNAME"),
        detail: LoginRejectionDetail.from_wire(detail)
      }
    end

    defp decode_failure(reason, <<>>) do
      %Failure{reason: LoginRejectionReason.from_wire(reason)}
    end
  end
end
