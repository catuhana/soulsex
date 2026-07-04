defmodule Soulsex.Connection.Message.Processor do
  @moduledoc false

  require Logger

  alias Soulseek.Server.Codes
  alias Soulseek.Wire
  alias Soulsex.Connection.Message.{Decoder, Dispatcher}
  alias Soulsex.Connection.State

  @spec process(binary(), State.t()) :: Soulsex.Handler.result()
  def process(body, state) do
    {code, payload} = Wire.take_uint32(body)

    case Codes.module(code) do
      nil ->
        Logger.warning("unknown server code #{code}")
        {:ok, state}

      module ->
        dispatch_decoded(module, payload, state)
    end
  end

  defp dispatch_decoded(module, payload, state) do
    case Decoder.decode(module, payload) do
      :ignore -> {:ok, state}
      message -> Dispatcher.dispatch(module, message, state)
    end
  end
end
