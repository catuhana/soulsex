defmodule Soulseek.Message do
  @moduledoc "Behaviour for protocol messages that encode to and decode from the wire."

  @type t :: struct()

  @callback encode(t()) :: iodata()
  @callback decode(binary()) :: t()

  @spec resolve_decoder(module()) :: module()
  def resolve_decoder(namespace), do: resolve(namespace, Request, :decode, 1)

  # TODO: I wrongly assumed all messages are bi-directional,
  # but some messages don't/shouldn't have encoder at all.
  # Here for now to make Dialyzer happy, and committing
  # jolly.
  @spec resolve_encoder(module()) :: {module(), module()}
  def resolve_encoder(struct_module) do
    namespace =
      if implements?(struct_module, :encode, 1),
        do: struct_module,
        else: parent_module(struct_module)

    {namespace, resolve(namespace, Response, :encode, 1)}
  end

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

  @spec parent_module(module()) :: module()
  defp parent_module(module) do
    case module |> Module.split() |> Enum.drop(-1) do
      [] -> module
      parts -> Module.concat(parts)
    end
  end

  @spec implements?(module(), atom(), arity()) :: boolean()
  defp implements?(module, fun, arity),
    do: Code.ensure_loaded?(module) and function_exported?(module, fun, arity)
end
