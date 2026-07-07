defmodule Soulsex.Connection.Message.Processor do
  @moduledoc false

  require Logger

  alias Soulseek.Server.Codes
  alias Soulseek.Wire
  alias Soulsex.Connection.Message.Decoder
  alias Soulsex.Connection.State
  alias Soulsex.Handler.Registry

  @spec process(binary(), State.t()) :: Soulsex.Handler.result()
  def process(body, state) do
    {code, payload} = Wire.take_uint32(body)

    Codes.module(code)
    |> case do
      nil ->
        Logger.warning("unknown server code #{code}")
        {:ok, state}

      module ->
        dispatch_decoded(module, payload, state)
    end
  end

  defp dispatch_decoded(module, payload, state) do
    Decoder.decode(module, payload)
    |> case do
      :ignore -> {:ok, state}
      message -> Registry.dispatch(module, message, state)
    end
  end
end
