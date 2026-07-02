defmodule Soulseek.Server.CantConnectToPeer do
  @moduledoc """
  The CantConnectToPeer message (server code 1001).

  The client sends a `Request` (token and username) when it can't respond to an
  indirect connection request; the server forwards a `Response` (token) to the
  peer that initiated it. The token comes from `ConnectToPeer`.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "A failed indirect connection report, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:token, :username]
    defstruct [:token, :username]

    @type t :: %__MODULE__{token: non_neg_integer(), username: String.t()}

    @impl true
    def decode(binary) do
      {token, rest} = Wire.take_uint32(binary)
      {username, <<>>} = Wire.take_string(rest)

      %__MODULE__{token: token, username: username}
    end
  end

  defmodule Response do
    @moduledoc "A forwarded failed indirect connection report, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:token]
    defstruct [:token]

    @type t :: %__MODULE__{token: non_neg_integer()}

    @impl true
    def decode(<<token::little-32>>), do: %__MODULE__{token: token}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.CantConnectToPeer.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.CantConnectToPeer.Request{token: token, username: username}),
    do: [Wire.uint32(token), Wire.string(username)]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.CantConnectToPeer.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.CantConnectToPeer.Response{token: token}), do: Wire.uint32(token)
end
