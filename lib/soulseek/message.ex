defmodule Soulseek.Message do
  @moduledoc "Behaviour for protocol messages that encode to and decode from the wire."

  @callback encode(struct()) :: iodata()
  @callback decode(binary()) :: struct()
end
