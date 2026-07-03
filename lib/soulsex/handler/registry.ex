defmodule Soulsex.Handler.Registry do
  @moduledoc """
  Registry of message handlers using a naming convention.
  """

  alias Soulseek.Server.Codes

  @spec handler(module()) :: module() | nil

  for message_module <- Codes.modules() do
    handler_module =
      Module.concat(
        Soulsex.Handler,
        message_module
        |> Module.split()
        |> List.last()
      )

    case Code.ensure_compiled(handler_module) do
      {:module, ^handler_module} ->
        def handler(unquote(message_module)), do: unquote(handler_module)

      {:error, _reason} ->
        :ok
    end
  end

  def handler(_message_module), do: nil
end
