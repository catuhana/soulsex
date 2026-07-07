defmodule Soulseek.Server.GivePrivileges do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:username, :days]
  defstruct [:username, :days]

  @type t :: %__MODULE__{username: String.t(), days: non_neg_integer()}

  @impl true
  def decode(binary) do
    {username, rest} = Wire.take_string(binary)
    {days, <<>>} = Wire.take_uint32(rest)

    %__MODULE__{username: username, days: days}
  end
end
