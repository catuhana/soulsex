defmodule Soulsex.Connection do
  @moduledoc """
  `:ranch` protocol that accepts an incoming Soulseek server connection.

  Each accepted socket gets its own process. The process buffers incoming bytes,
  peels complete protocol frames off the buffer, decodes each as a client-to-server
  message, and logs it (redacting credentials). Malformed or unknown messages are
  logged and skipped; an oversized frame closes the connection.
  """

  @behaviour :ranch_protocol

  require Logger

  alias Soulseek.{Frame, Message, Wire}
  alias Soulseek.Server.Codes
  alias Soulsex.Connection.State

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
        state = %{state | buffer: state.buffer <> data}

        case process(state) do
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
    end
  end

  @spec process(State.t()) :: {:cont, State.t()} | :stop
  defp process(%State{buffer: buffer} = state) do
    case Frame.decode(buffer, @max_message_size) do
      {:ok, body, rest} ->
        case handle_message(body, %{state | buffer: rest}) do
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

  @spec handle_message(binary(), State.t()) :: {:cont, State.t()} | :stop
  defp handle_message(body, state) do
    {code, payload} = Wire.take_uint32(body)

    case Codes.module(code) do
      nil ->
        Logger.warning("unknown server code #{code}")
        {:cont, state}

      module ->
        case decode_payload(module, payload) do
          :ignore ->
            {:cont, state}

          message ->
            dispatch(module, message, state)
        end
    end
  end

  @spec dispatch(module(), Message.t(), State.t()) :: {:cont, State.t()} | :stop
  defp dispatch(module, message, state) do
    case Soulsex.Handler.Registry.handler(module) do
      nil ->
        Logger.warning("unhandled server message: #{inspect(message)}")
        {:cont, state}

      handler ->
        handler.handle_message(message, state)
        |> handle_message_result
    end
  end

  @spec handle_message_result(
          {:ok, State.t()}
          | {:reply, Message.t(), State.t()}
          | {:error, term(), State.t()}
        ) :: {:cont, State.t()} | :stop
  defp handle_message_result({:ok, state}), do: {:cont, state}

  defp handle_message_result({:reply, response, state}) do
    send_message(state, response)
    {:cont, state}
  end

  defp handle_message_result({:reply_and_close, response, state}) do
    send_message(state, response)
    :stop
  end

  defp handle_message_result({:error, reason, state}) do
    Logger.warning("failed to handle server message: #{inspect(reason)}")
    {:cont, state}
  end

  @spec send_message(State.t(), Message.t()) :: :ok
  defp send_message(%State{socket: socket, transport: transport}, response) do
    code = Codes.code(response.__struct__)
    encoded = Message.Encoder.encode(response)

    socket
    |> transport.send(Frame.encode(code, encoded))
  end

  @spec decode_payload(module(), binary()) :: Message.t() | :ignore
  defp decode_payload(module, payload) do
    Code.ensure_loaded(module)

    if function_exported?(module, :decode, 1) do
      # credo:disable-for-next-line
      apply(module, :decode, [payload])
    else
      request_module = Module.concat(module, Request)
      Code.ensure_loaded(request_module)

      if function_exported?(request_module, :decode, 1) do
        # credo:disable-for-next-line
        apply(request_module, :decode, [payload])
      else
        :ignore
      end
    end
  end
end
