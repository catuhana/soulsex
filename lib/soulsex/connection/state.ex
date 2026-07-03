defmodule Soulsex.Connection.State do
  @moduledoc """
  State of a Soulseek connection process.
  """

  @type t :: %__MODULE__{
          socket: :ranch_transport.socket(),
          transport: module(),
          buffer: binary(),
          user_id: pos_integer() | nil,
          username: String.t() | nil
        }

  defstruct [:socket, :transport, :user_id, :username, buffer: <<>>]
end
