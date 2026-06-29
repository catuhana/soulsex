defmodule Soulseek.Server.PrivilegedUsers do
  @moduledoc """
  The PrivilegedUsers message (server code 69).

  The server sends a list of privileged users (those who have donated). The
  client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:users]
  defstruct [:users]

  @type t :: %__MODULE__{users: [String.t()]}

  @impl true
  def encode(%__MODULE__{users: users}), do: Wire.array(users, &Wire.string/1)

  @impl true
  def decode(binary) do
    {users, <<>>} = Wire.take_array(binary, &Wire.take_string/1)

    %__MODULE__{users: users}
  end
end
