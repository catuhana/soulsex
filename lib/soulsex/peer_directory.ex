defmodule Soulsex.PeerDirectory do
  @moduledoc false

  alias Soulsex.PeerDirectory.Entry
  alias Soulsex.PeerDirectory.Entry.{Connected, Pending}

  @registry __MODULE__

  @spec child_spec(term()) :: Supervisor.child_spec()
  def child_spec(_opts),
    do: Registry.child_spec(keys: :unique, name: @registry)

  @spec register(
          String.t(),
          Entry.t()
        ) ::
          {
            :ok,
            pid()
          }
          | {
              :error,
              {:already_logged_in, pid()}
            }
  def register(username, entry) do
    Registry.register(@registry, username, entry)
    |> case do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_registered, old_pid}} ->
        {:error, {:already_logged_in, old_pid}}
    end
  end

  @spec set_wait_port(
          String.t(),
          Soulseek.Server.SetWaitPort.t()
        ) ::
          {
            :ok,
            {
              Connected.t(),
              Pending.t() | Connected.t()
            }
          }
          | {:error, :not_registered}
  def set_wait_port(username, %Soulseek.Server.SetWaitPort{
        port: port,
        obfuscation_type: obfuscation_type,
        obfuscated_port: obfuscated_port
      }) do
    Registry.update_value(@registry, username, fn
      %Pending{ip: ip} ->
        %Connected{
          ip: ip,
          port: port,
          obfuscation_type: obfuscation_type,
          obfuscated_port: obfuscated_port
        }

      %Connected{} = already ->
        already
    end)
    |> case do
      {%Connected{} = new_entry, old_entry} -> {:ok, {new_entry, old_entry}}
      :error -> {:error, :not_registered}
    end
  end

  @spec lookup(String.t()) ::
          {:ok, {pid(), Entry.t()}}
          | {:error, :not_registered}
  def lookup(username) do
    Registry.lookup(@registry, username)
    |> case do
      [{pid, entry}] -> {:ok, {pid, entry}}
      [] -> {:error, :not_registered}
    end
  end
end
