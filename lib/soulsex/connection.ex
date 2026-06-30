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

  @max_message_size 469_762_048

  @impl true
  def start_link(ref, transport, opts),
    do: {:ok, :proc_lib.spawn_link(__MODULE__, :init, [ref, transport, opts])}

  @spec init(:ranch.ref(), module(), term()) :: :ok
  def init(ref, transport, _opts) do
    {:ok, socket} = :ranch.handshake(ref)

    loop(socket, transport, <<>>)
  end

  @spec loop(:ranch_transport.socket(), module(), binary()) :: :ok
  defp loop(socket, transport, buffer) do
    transport.setopts(socket, active: :once)

    receive do
      {:tcp, ^socket, data} ->
        case process(buffer <> data) do
          {:cont, buffer} ->
            loop(socket, transport, buffer)

          :close ->
            transport.close(socket)
            :ok
        end

      {:tcp_closed, ^socket} ->
        :ok

      {:tcp_error, ^socket, _reason} ->
        :ok
    end
  end

  @spec process(binary()) :: {:cont, binary()} | :close
  defp process(buffer) do
    case Frame.decode(buffer, @max_message_size) do
      {:ok, body, rest} ->
        handle_message(body)
        process(rest)

      :more ->
        {:cont, buffer}

      {:error, :too_large} ->
        Logger.warning("server frame exceeds #{@max_message_size} bytes; closing connection")
        :close
    end
  end

  @spec handle_message(binary()) :: :ok
  defp handle_message(body) do
    {code, payload} = Wire.take_uint32(body)

    case Codes.module(code) do
      nil ->
        Logger.warning("unknown server code #{code}")

      module ->
        decoder = decoder(module)
        message = decoder.decode(payload)

        Logger.debug("recv #{code} #{inspect(redact(message))}")
    end

    :ok
  rescue
    # The protocol decoders are strict and raise on malformed input. Catching
    # here to log and skip a bad frame, keeping the connection open as the
    # official server does, is a deliberate boundary, not control flow by
    # exception.
    error -> Logger.warning("failed to handle server frame: #{inspect(error)}")
  end

  @spec decoder(module()) :: module()
  defp decoder(module) do
    request = Module.concat(module, Request)

    if Code.ensure_loaded?(request) and function_exported?(request, :decode, 1),
      do: request,
      else: module
  end

  defp redact(%Soulseek.Server.Login.Request{} = request),
    do: %{request | password: "[REDACTED]", hash: "[REDACTED]"}

  defp redact(%Soulseek.Server.ChangePassword{} = message),
    do: %{message | password: "[REDACTED]"}

  defp redact(message), do: message
end
