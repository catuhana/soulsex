defmodule Soulseek.Message do
  @moduledoc "Behaviour for protocol messages that encode to and decode from the wire."

  @type t :: struct()

  @callback encode(t()) :: iodata()
  @callback decode(binary()) :: t()
end
