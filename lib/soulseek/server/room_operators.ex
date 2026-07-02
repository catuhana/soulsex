defmodule Soulseek.Server.RoomOperators do
  @moduledoc """
  The RoomOperators message (server code 148).

  The server sends the list of operators of a private room we are in. The client
  sends no such message.
  """

  @enforce_keys [:room, :operators]
  defstruct [:room, :operators]

  @type t :: %__MODULE__{room: String.t(), operators: [String.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.RoomOperators do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.RoomOperators{room: room, operators: operators}),
    do: [Wire.string(room), Wire.array(operators, &Wire.string/1)]
end
