defmodule Soulseek.Server.PossibleParents do
  @moduledoc """
  The PossibleParents message (server code 102).

  The server sends a list of possible distributed parents to connect to. The
  client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  defmodule Parent do
    @moduledoc "A possible distributed parent's address."

    @enforce_keys [:username, :ip, :port]
    defstruct [:username, :ip, :port]

    @type t :: %__MODULE__{username: String.t(), ip: non_neg_integer(), port: 0..65_535}
  end

  @enforce_keys [:parents]
  defstruct [:parents]

  @type t :: %__MODULE__{parents: [Parent.t()]}

  @impl true
  def encode(%__MODULE__{parents: parents}) do
    Wire.array(parents, &encode_parent/1)
  end

  defp encode_parent(%Parent{username: username, ip: ip, port: port}) do
    [Wire.string(username), Wire.uint32(ip), Wire.uint32(port)]
  end

  @impl true
  def decode(binary) do
    {parents, <<>>} = Wire.take_array(binary, &take_parent/1)
    %__MODULE__{parents: parents}
  end

  defp take_parent(binary) do
    {username, rest} = Wire.take_string(binary)
    {ip, rest} = Wire.take_uint32(rest)
    {port, rest} = Wire.take_uint32(rest)
    {%Parent{username: username, ip: ip, port: port}, rest}
  end
end
