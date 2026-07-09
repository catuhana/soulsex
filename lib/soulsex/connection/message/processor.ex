defmodule Soulsex.Connection.Message.Processor do
  @moduledoc false

  alias Soulseek.Server.Codes
  alias Soulseek.Wire
  alias Soulsex.Connection.Message.Decoder
  alias Soulsex.Connection.State
  alias Soulsex.Handler.Registry

  @spec process(binary(), State.t()) :: Soulsex.Handler.result()
  def process(body, state) do
    {code, payload} = Wire.take_uint32(body)

    Codes.module(code)
    |> case do
      nil ->
        {:error, {:unknown_code, code}, state}

      module ->
        Decoder.decode(module, payload)
        |> case do
          {:ok, message} -> Registry.dispatch(module, message, state)
          {:error, :decode_failed} -> {:error, {:decode_failed, module}, state}
        end
    end
  end
end
