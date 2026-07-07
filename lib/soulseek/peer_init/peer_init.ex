defmodule Soulseek.PeerInit.PeerInit do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.{ConnectionType, Wire}

  @enforce_keys [:username, :type]
  defstruct [:username, :type, token: 0]

  @type t :: %__MODULE__{
          username: String.t(),
          type: ConnectionType.t(),
          token: non_neg_integer()
        }

  @impl true
  def decode(binary) do
    {username, rest} = Wire.take_string(binary)
    {type, rest} = Wire.take_string(rest)
    {token, <<>>} = Wire.take_uint32(rest)

    %__MODULE__{username: username, type: ConnectionType.from_wire(type), token: token}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.PeerInit.PeerInit do
  alias Soulseek.{ConnectionType, Wire}

  def encode(%Soulseek.PeerInit.PeerInit{username: username, type: type, token: token}),
    do: [
      Wire.string(username),
      type
      |> ConnectionType.to_wire()
      |> Wire.string(),
      Wire.uint32(token)
    ]
end
