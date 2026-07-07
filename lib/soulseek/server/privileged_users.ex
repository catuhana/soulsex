defmodule Soulseek.Server.PrivilegedUsers do
  @moduledoc false

  @enforce_keys [:users]
  defstruct [:users]

  @type t :: %__MODULE__{users: [String.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.PrivilegedUsers do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.PrivilegedUsers{users: users}),
    do: Wire.array(users, &Wire.string/1)
end
