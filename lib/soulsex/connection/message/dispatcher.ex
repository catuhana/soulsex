defmodule Soulsex.Connection.Message.Dispatcher do
  @moduledoc false

  require Logger

  alias Soulseek.Message
  alias Soulsex.Connection.State

  @spec dispatch(module(), Message.t(), State.t()) :: Soulsex.Handler.result()
  def dispatch(module, message, state) do
    case Soulsex.Handler.Registry.handler(module) do
      nil ->
        Logger.warning("unhandled server message: #{inspect(message)}")
        {:ok, state}

      handler ->
        handler.handle_message(message, state)
    end
  end
end
