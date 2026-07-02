defmodule Soulsex.HandlerRegistry do
  @moduledoc """
  Registry of message handlers using a naming convention.

  Instead of maintaining an explicit map, handlers are discovered dynamically using
  a naming convention: `Soulseek.Server.Login` → `Soulsex.Handlers.Login`.
  """

  # TODO: Do a compile-time generation of a map of message modules to handler modules,
  # to avoid the reflection cost on every message.
  @spec handler(module()) :: module() | nil
  def handler(message_module) do
    handler_module =
      Module.concat(Soulsex.Handlers, message_module |> Module.split() |> List.last())

    if Code.ensure_loaded?(handler_module) and
         function_exported?(handler_module, :handle_message, 2),
       do: handler_module,
       else: nil
  end
end
