defmodule Soulsex.Handler.Registry do
  @moduledoc false

  require Logger

  alias Soulseek.Message
  alias Soulseek.Server.Codes
  alias Soulsex.Connection.State
  alias Soulsex.Handler

  @spec dispatch(module(), Message.t(), State.t()) :: Handler.result()

  for message_module <- Codes.modules(),
      Codes.module(Codes.code(message_module)) == message_module do
    code = Codes.code(message_module)

    handler_module =
      Module.concat(
        Soulsex.Handler,
        message_module
        |> Module.split()
        |> List.last()
      )

    case Code.ensure_compiled(handler_module) do
      {:module, ^handler_module} ->
        callback =
          cond do
            function_exported?(handler_module, :respond, 2) ->
              :respond

            function_exported?(handler_module, :acknowledge, 2) ->
              :acknowledge

            true ->
              raise "#{inspect(handler_module)} implements neither Repliable nor Notification"
          end

        def dispatch(unquote(message_module), message, state) do
          unquote(handler_module).unquote(callback)(message, state)
        end

      {:error, _reason} ->
        def dispatch(unquote(message_module), message, state) do
          Logger.warning(
            "not implemented server message code=#{unquote(code)} message=#{inspect(message)}"
          )

          {:ok, state}
        end
    end
  end
end
