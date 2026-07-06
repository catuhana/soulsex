defmodule Soulsex.Handler.Registry do
  @moduledoc """
  Compile-time registry of message handlers.
  """

  require Logger

  alias Soulseek.Message
  alias Soulseek.Server.Codes
  alias Soulsex.Connection.State
  alias Soulsex.Handler

  @spec dispatch(
          module(),
          Message.t(),
          State.t()
        ) :: Handler.result()

  for message_module <- Codes.modules() do
    handler_module =
      Module.concat(
        Soulsex.Handler,
        message_module
        |> Module.split()
        |> List.last()
      )

    Code.ensure_compiled(handler_module)
    |> case do
      {:module, ^handler_module} ->
        callback =
          cond do
            function_exported?(handler_module, :respond, 2) ->
              :respond

            function_exported?(handler_module, :acknowledge, 2) ->
              :acknowledge

            true ->
              raise "#{inspect(handler_module)} implements neither " <>
                      "Soulsex.Handler.Repliable nor Soulsex.Handler.Notification"
          end

        def dispatch(unquote(message_module), message, state) do
          unquote(handler_module).unquote(callback)(message, state)
        end

      {:error, _reason} ->
        :ok
    end
  end

  def dispatch(_message_module, message, state) do
    Logger.warning("unhandled server message=#{inspect(message)}")

    {:ok, state}
  end
end
