defmodule Soulsex.Handler.SetWaitPort do
  @moduledoc false

  require Logger

  @behaviour Soulsex.Handler

  alias Soulseek.Server.SetWaitPort
  alias Soulsex.Connection.State
  alias Soulsex.PeerDirectory

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

    PeerDirectory.set_wait_port(
      state.username,
      %SetWaitPort{
        port: port,
        obfuscation_type: obfuscation_type,
        obfuscated_port: obfuscated_port
      }
    )
    |> case do
      {_new_entry, _old_entry} ->
        {:ok, state}

      :error ->
        {:stop, {:unregistered_peer, state.username}, state}
    end
  end
end
