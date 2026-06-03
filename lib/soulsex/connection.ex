defmodule Soulsex.Connection do
  @moduledoc """
  `:ranch` protocol that accepts an incoming Soulseek connection.

  Each accepted socket gets its own process. For now the process completes the
  `:ranch` handshake to take ownership of the connection and then holds it open,
  exiting once the peer disconnects.
  """

  @behaviour :ranch_protocol

  require Logger

  @impl true
  def start_link(ref, transport, opts) do
    {:ok, :proc_lib.spawn_link(__MODULE__, :init, [ref, transport, opts])}
  end

  @spec init(:ranch.ref(), module(), term()) :: :ok
  def init(ref, transport, _opts) do
    {:ok, socket} = :ranch.handshake(ref)
    loop(socket, transport)
  end

  @spec loop(:ranch_transport.socket(), module()) :: :ok
  defp loop(socket, transport) do
    transport.setopts(socket, active: :once)

    receive do
      {:tcp, ^socket, data} ->
        Logger.info("received #{byte_size(data)} bytes: #{inspect(data)}")
        loop(socket, transport)

      {:tcp_closed, ^socket} ->
        :ok

      {:tcp_error, ^socket, _} ->
        :ok
    end
  end
end
