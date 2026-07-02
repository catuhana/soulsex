defmodule Soulseek.Server.PossibleParents do
  @moduledoc """
  The PossibleParents message (server code 102).

  The server sends a list of possible distributed parents to connect to. The
  client sends no such message.
  """

  defmodule Parent do
    @moduledoc "A possible distributed parent's address."

    @enforce_keys [:username, :ip, :port]
    defstruct [:username, :ip, :port]

    @type t :: %__MODULE__{username: String.t(), ip: non_neg_integer(), port: 0..65_535}
  end

  @enforce_keys [:parents]
  defstruct [:parents]

  @type t :: %__MODULE__{parents: [Parent.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.PossibleParents do
  alias Soulseek.Wire

  alias Soulseek.Server.PossibleParents.Parent

  def encode(%Soulseek.Server.PossibleParents{parents: parents}),
    do: Wire.array(parents, &encode_parent/1)

  defp encode_parent(%Parent{username: username, ip: ip, port: port}),
    do: [Wire.string(username), Wire.uint32(ip), Wire.uint32(port)]
end
