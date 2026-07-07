defmodule Soulseek.Server.UnwatchUser do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:username]
  defstruct [:username]

  @type t :: %__MODULE__{username: String.t()}

  @impl true
  def decode(binary) do
    {username, <<>>} = Wire.take_string(binary)

    %__MODULE__{username: username}
  end
end
