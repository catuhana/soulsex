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

  alias Soulseek.{Frame, Wire}
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
        handle_message(body, %{state | buffer: rest})
        |> process

      :more ->
        {:cont, state}

      {:error, :too_large} ->
        Logger.warning("server frame exceeds #{@max_message_size} bytes; closing connection")
        :stop
    end
  end

  @spec handle_message(binary(), State.t()) :: State.t()
  defp handle_message(body, state) do
    {code, payload} = Wire.take_uint32(body)

    case Codes.module(code) do
      nil ->
        Logger.warning("unknown server code #{code}")
        state

      module ->
        decoder = decoder(module)
        message = decoder.decode(payload)

        dispatch(module, message, state)
    end
  rescue
    # The protocol decoders are strict and raise on malformed input. Catching
    # here to log and skip a bad frame, keeping the connection open as the
    # official server does, is a deliberate boundary, not control flow by
    # exception.
    error ->
      Logger.warning("failed to handle server frame: #{inspect(error)}")
      state
  end

  @spec dispatch(module(), Soulseek.Message.t(), State.t()) :: State.t()
  defp dispatch(module, message, state) do
    case Soulsex.HandlerRegistry.handler(module) do
      nil ->
        Logger.warning("unhandled server message: #{inspect(message)}")
        state

      handler ->
        handler.handle_message(message, state)
        |> handle_message_result
    end
  end

  @spec handle_message_result(
          {:ok, State.t()}
          | {:reply, Soulseek.Message.t(), State.t()}
          | {:error, term(), State.t()}
        ) :: State.t()
  defp handle_message_result({:ok, new_state}), do: new_state

  defp handle_message_result({:reply, response, new_state}) do
    send_message(new_state, response)
    new_state
  end

  defp handle_message_result({:error, reason, new_state}) do
    Logger.warning("failed to handle server message: #{inspect(reason)}")
    new_state
  end

  @spec send_message(State.t(), Soulseek.Message.t()) :: :ok
  defp send_message(%State{socket: socket, transport: transport}, response) do
    {namespace, encoder} = encoder(response.__struct__)
    encoded = encoder.encode(response)
    code = Codes.code(namespace)

    transport.send(socket, [<<code::little-unsigned-32>>, encoded])
  end

  # TODO: Move to a separate module I think. Also fix/improve the discovery
  # of `encoder` (and `decoder` for the next function).
  @spec encoder(module()) :: {module(), module()}
  defp encoder(struct_module) do
    parent = struct_module |> Module.split() |> Enum.drop(-1) |> Module.concat()
    response = Module.concat(parent, Response)

    if Code.ensure_loaded?(response) and function_exported?(response, :encode, 1) do
      {parent, response}
    else
      {struct_module, struct_module}
    end
  end

  # TODO: Ditto.
  @spec decoder(module()) :: module()
  defp decoder(module) do
    request = Module.concat(module, Request)

    if Code.ensure_loaded?(request) and function_exported?(request, :decode, 1),
      do: request,
      else: module
  end
end
