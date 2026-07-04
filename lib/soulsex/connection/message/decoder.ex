defmodule Soulsex.Connection.Message.Decoder do
  @moduledoc false

  alias Soulseek.Message

  @spec decode(module(), binary()) :: Message.t() | :ignore
  def decode(module, payload) do
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
