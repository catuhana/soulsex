defmodule Soulseek.Server.UnwatchUser do
  @moduledoc """
  The UnwatchUser message (server code 6).

  The client sends this to stop being kept updated about a user's status. The
  server sends no reply.
  """

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
