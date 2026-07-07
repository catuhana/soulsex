defmodule Soulseek.File.TransferInit do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:token]
  defstruct [:token]

  @type t :: %__MODULE__{token: non_neg_integer()}

  @impl true
  def decode(binary) do
    {token, <<>>} = Wire.take_uint32(binary)

    %__MODULE__{token: token}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.File.TransferInit do
  alias Soulseek.Wire

  def encode(%Soulseek.File.TransferInit{token: token}), do: Wire.uint32(token)
end
