defmodule Soulsex.Handler.SetWaitPort do
  @moduledoc false

  require Logger

  alias Soulseek.Server.SetWaitPort
  alias Soulsex.Connection.State
  alias Soulsex.Handler.Notification
  alias Soulsex.PeerDirectory

  @behaviour Notification

  @impl true
  @spec acknowledge(SetWaitPort.t(), State.t()) :: Notification.result()
  def acknowledge(
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
      {:ok, {_new_entry, _old_entry}} ->
        {:ok, state}

      {:error, :not_registered} ->
        {:error, {:unregistered_peer, state.username}, state}
    end
  end
end
