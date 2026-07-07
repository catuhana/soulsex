defmodule Soulseek.Server.CantConnectToPeer do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

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
    @moduledoc false

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
