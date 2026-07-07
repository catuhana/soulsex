defmodule Soulseek.Server.MessageUsers do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:usernames, :message]
  defstruct [:usernames, :message]

  @type t :: %__MODULE__{usernames: [String.t()], message: String.t()}

  @impl true
  def decode(binary) do
    {usernames, rest} = Wire.take_array(binary, &Wire.take_string/1)
    {message, <<>>} = Wire.take_string(rest)

    %__MODULE__{usernames: usernames, message: message}
  end
end
