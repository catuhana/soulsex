defmodule Soulseek.Server.Login do
  @moduledoc false

  alias Soulseek.{LoginRejectionDetail, LoginRejectionReason, Wire}

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    @derive {
      Inspect,
      except: [:password, :hash]
    }

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
    @moduledoc false

    @derive {
      Inspect,
      except: [:hash]
    }

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
    @moduledoc false

    @enforce_keys [:reason]
    defstruct [:reason, :detail]

    @type t :: %__MODULE__{
            reason: LoginRejectionReason.t(),
            detail: LoginRejectionDetail.t() | nil
          }
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @type t :: Success.t() | Failure.t()

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

    defp decode_failure(reason, <<>>),
      do: %Failure{reason: LoginRejectionReason.from_wire(reason)}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Login.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.Login.Request{} = struct),
    do: [
      Wire.string(struct.username),
      Wire.string(struct.password),
      Wire.uint32(struct.version_major),
      Wire.string(struct.hash),
      Wire.uint32(struct.version_minor)
    ]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Login.Success do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.Login.Success{} = success),
    do: [
      Wire.bool(true),
      Wire.string(success.greet),
      Wire.uint32(success.ip_address),
      Wire.string(success.hash),
      Wire.bool(success.supporter)
    ]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.Login.Failure do
  alias Soulseek.{LoginRejectionDetail, LoginRejectionReason, Wire}

  def encode(%Soulseek.Server.Login.Failure{reason: :invalid_username, detail: detail}),
    do: [
      Wire.bool(false),
      :invalid_username
      |> LoginRejectionReason.to_wire()
      |> Wire.string(),
      detail
      |> LoginRejectionDetail.to_wire()
      |> Wire.string()
    ]

  def encode(%Soulseek.Server.Login.Failure{reason: reason}),
    do: [
      Wire.bool(false),
      reason
      |> LoginRejectionReason.to_wire()
      |> Wire.string()
    ]
end
