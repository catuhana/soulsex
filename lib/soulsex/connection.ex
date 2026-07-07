defmodule Soulsex.Connection do
  @moduledoc false

  @behaviour :ranch_protocol

  require Logger

  alias Soulseek.{Frame, Message}
  alias Soulseek.Server.Codes
  alias Soulsex.Connection.Message.Processor
  alias Soulsex.Connection.State
  alias Soulsex.Handler

  @max_message_size 448 * 1024 * 1024

  @impl true
  def start_link(ref, transport, opts),
    do: {:ok, :proc_lib.spawn_link(__MODULE__, :init, [ref, transport, opts])}

  @spec init(:ranch.ref(), module(), term()) :: :ok
  def init(ref, transport, _opts) do
    {:ok, socket} = :ranch.handshake(ref)

    %State{socket: socket, transport: transport}
    |> loop
  end

  @spec loop(State.t()) :: :ok
  defp loop(%State{socket: socket, transport: transport} = state) do
    transport.setopts(socket, active: :once)

    receive do
      {:tcp, ^socket, data} ->
        state = %{state | in_buffer: state.in_buffer <> data}

        process(state)
        |> case do
          {:cont, state} ->
            loop(state)

          :stop ->
            transport.close(socket)
            :ok
        end

      {:tcp_closed, ^socket} ->
        :ok

      {:tcp_error, ^socket, reason} ->
        Logger.error("error on socket #{inspect(socket)}: #{inspect(reason)}")
        :ok

      :relogged ->
        send_message(state, %Soulseek.Server.Relogged{})
        transport.close(socket)
        :ok
    end
  end

  @spec process(State.t()) :: {:cont, State.t()} | :stop
  defp process(%State{in_buffer: in_buffer} = state) do
    Frame.decode(in_buffer, @max_message_size)
    |> case do
      {:ok, body, rest} ->
        Processor.process(body, %{state | in_buffer: rest})
        |> handle_message_result()
        |> case do
          {:cont, state} ->
            process(state)

          :stop ->
            :stop
        end

      :more ->
        {:cont, state}

      {:error, :too_large} ->
        Logger.warning("server frame exceeds #{@max_message_size} bytes; closing connection")
        :stop
    end
  end

  @spec handle_message_result(Handler.result()) ::
          {
            :cont,
            State.t()
          }
          | :stop
  defp handle_message_result({:ok, state}), do: {:cont, state}

  defp handle_message_result({:reply, response, state}) do
    send_message(state, response)
    {:cont, state}
  end

  defp handle_message_result({:reply_and_close, response, state}) do
    send_message(state, response)
    :stop
  end

  defp handle_message_result({:error, reason, _state}) do
    Logger.warning("failed to handle server message: #{inspect(reason)}")
    :stop
  end

  defp handle_message_result(:close) do
    :stop
  end

  @spec send_message(State.t(), Message.t()) :: :ok
  defp send_message(%State{socket: socket, transport: transport}, response) do
    code = Codes.code(response.__struct__)
    encoded = Message.Encoder.encode(response)

    socket
    |> transport.send(Frame.encode(code, encoded))
  end
end
