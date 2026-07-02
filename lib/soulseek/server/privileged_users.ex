defmodule Soulseek.Server.PrivilegedUsers do
  @moduledoc """
  The PrivilegedUsers message (server code 69).

  The server sends a list of privileged users (those who have donated). The
  client sends no such message.
  """

  @enforce_keys [:users]
  defstruct [:users]

  @type t :: %__MODULE__{users: [String.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.PrivilegedUsers do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.PrivilegedUsers{users: users}),
    do: Wire.array(users, &Wire.string/1)
end
