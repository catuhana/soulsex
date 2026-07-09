defmodule Soulsex.Connection.Message.Decoder do
  @moduledoc false

  alias Soulseek.Message

  @spec decode(module(), binary()) :: {:ok, Message.t()} | {:error, :decode_failed}
  def decode(module, payload) do
    decoder = Message.resolve_decoder(module)
    {:ok, decoder.decode(payload)}
  rescue
    _ -> {:error, :decode_failed}
  end
end
