defmodule Soulseek.Server.GivePrivileges do
  @moduledoc """
  The GivePrivileges message (server code 123).

  The client gives part of its privileges (in days) to another user. The server
  sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:username, :days]
  defstruct [:username, :days]

  @type t :: %__MODULE__{username: String.t(), days: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{username: username, days: days}),
    do: [Wire.string(username), Wire.uint32(days)]

  @impl true
  def decode(binary) do
    {username, rest} = Wire.take_string(binary)
    {days, <<>>} = Wire.take_uint32(rest)

    %__MODULE__{username: username, days: days}
  end
end
