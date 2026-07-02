defmodule Soulseek.Message do
  @moduledoc "Behaviour for protocol messages that encode to and decode from the wire."

  @type t :: struct()

  @callback decode(binary()) :: t()

  @optional_callbacks decode: 1

  @spec resolve_decoder(module()) :: module()
  def resolve_decoder(namespace), do: resolve(namespace, Request, :decode, 1)

  @spec resolve(module(), module(), atom(), arity()) :: module()
  defp resolve(module, submodule, fun, arity) do
    cond do
      implements?(module, fun, arity) ->
        module

      implements?(fallback = Module.concat(module, submodule), fun, arity) ->
        fallback

      true ->
        raise "#{inspect(module)} has no #{fun}/#{arity}, directly or via #{inspect(submodule)}"
    end
  end

  @spec implements?(module(), atom(), arity()) :: boolean()
  defp implements?(module, fun, arity),
    do: Code.ensure_loaded?(module) and function_exported?(module, fun, arity)
end
