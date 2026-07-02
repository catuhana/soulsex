defmodule Soulseek.Server.CheckPrivileges do
  @moduledoc """
  The CheckPrivileges message (server code 92).

  The client sends an empty `Request` to ask how much privilege time is left;
  the server replies with a `Response` carrying the remaining time in seconds.
  """

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc "An empty request for remaining privilege time, sent by the client to the server."

    @behaviour Soulseek.Message

    defstruct []

    @type t :: %__MODULE__{}

    @impl true
    def decode(<<>>), do: %__MODULE__{}
  end

  defmodule Response do
    @moduledoc "The remaining privilege time in seconds, sent by the server to the client."

    @behaviour Soulseek.Message

    @enforce_keys [:time_left]
    defstruct [:time_left]

    @type t :: %__MODULE__{time_left: non_neg_integer()}

    @impl true
    def decode(<<time_left::little-32>>), do: %__MODULE__{time_left: time_left}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.CheckPrivileges.Request do
  def encode(%Soulseek.Server.CheckPrivileges.Request{}), do: []
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.CheckPrivileges.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.CheckPrivileges.Response{time_left: time_left}),
    do: Wire.uint32(time_left)
end
