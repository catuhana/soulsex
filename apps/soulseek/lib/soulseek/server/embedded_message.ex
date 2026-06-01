defmodule Soulseek.Server.EmbeddedMessage do
  @moduledoc """
  The EmbeddedMessage message (server code 93).

  The server sends an embedded distributed message (a distributed code and the
  raw message bytes) when we are a branch root. The client sends no such
  message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:code, :message]
  defstruct [:code, :message]

  @type t :: %__MODULE__{code: non_neg_integer(), message: binary()}

  @impl true
  def encode(%__MODULE__{code: code, message: message}) do
    [Wire.uint8(code), Wire.bytes(message)]
  end

  @impl true
  def decode(binary) do
    {code, rest} = Wire.take_uint8(binary)
    {message, <<>>} = Wire.take_bytes(rest)
    %__MODULE__{code: code, message: message}
  end
end
