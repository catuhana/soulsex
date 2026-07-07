defmodule Soulseek.Server.ChangePassword do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:password]
  defstruct [:password]

  @type t :: %__MODULE__{password: String.t()}

  def decode(binary) do
    {password, <<>>} = Wire.take_string(binary)

    %__MODULE__{password: password}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ChangePassword do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ChangePassword{password: password}), do: Wire.string(password)
end
