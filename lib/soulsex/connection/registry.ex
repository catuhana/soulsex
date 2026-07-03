defmodule Soulsex.Connection.Registry do
  @moduledoc false

  require Logger

  alias Soulseek.ObfuscationType

  @registry __MODULE__

  @type meta :: %{
          ip: :inet.ip4_address(),
          port: :inet.port_number() | nil,
          obfuscation_type: ObfuscationType.t() | nil,
          obfuscated_port: :inet.port_number() | nil
        }

  @spec child_spec(term()) :: Supervisor.child_spec()
  def child_spec(_opts), do: Registry.child_spec(keys: :unique, name: @registry)

  @spec register(String.t(), meta()) :: {:ok, pid()} | {:error, {:already_registered, pid()}}
  def register(username, meta) do
    Logger.debug("add user registry=#{username}=#{inspect(meta)}")

    Registry.register(@registry, username, meta)
  end

  @spec update(String.t(), (meta() -> meta())) :: {meta(), meta()} | :error
  def update(username, fun) do
    case Registry.update_value(@registry, username, fun) do
      {new_meta, old_meta} ->
        Logger.debug("update user registry=#{username}=#{inspect(new_meta)}")
        {new_meta, old_meta}

      :error ->
        :error
    end
  end

  @spec lookup(String.t()) :: {pid(), meta()} | :error
  def lookup(username) do
    case Registry.lookup(@registry, username) do
      [{pid, meta}] ->
        Logger.debug("lookup user registry=#{username}=#{inspect(meta)}")

        {pid, meta}

      [] ->
        :error
    end
  end
end
