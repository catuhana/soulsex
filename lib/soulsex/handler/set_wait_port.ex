defmodule Soulsex.Handler.SetWaitPort do
  @moduledoc false

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.SetWaitPort
  alias Soulsex.Connection.{Registry, State}

  @impl true
  @spec handle_message(SetWaitPort.t(), State.t()) :: Soulsex.Handler.result()
  def handle_message(
        %SetWaitPort{
          port: port,
          obfuscation_type: obfuscation_type,
          obfuscated_port: obfuscated_port
        } = message,
        state
      ) do
    Logger.debug("#{inspect(__MODULE__)}=#{inspect(message)}")

    Registry.update(state.username, fn meta ->
      meta = %{
        meta
        | port: port,
          obfuscation_type: obfuscation_type,
          obfuscated_port: obfuscated_port
      }

      meta
    end)

    {:ok, state}
  end
end
