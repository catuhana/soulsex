defmodule Soulsex.Connection.State do
  @moduledoc """
  State of a Soulseek connection process.
  """

  @type t :: %__MODULE__{
          socket: :ranch_transport.socket(),
          transport: module(),
          buffer: binary()
        }

  defstruct [:socket, :transport, buffer: <<>>]
end
