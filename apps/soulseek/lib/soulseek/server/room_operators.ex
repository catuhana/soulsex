defmodule Soulseek.Server.RoomOperators do
  @moduledoc """
  The RoomOperators message (server code 148).

  The server sends the list of operators of a private room we are in. The client
  sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:room, :operators]
  defstruct [:room, :operators]

  @type t :: %__MODULE__{room: String.t(), operators: [String.t()]}

  @impl true
  def encode(%__MODULE__{room: room, operators: operators}) do
    [Wire.string(room), Wire.array(operators, &Wire.string/1)]
  end

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {operators, <<>>} = Wire.take_array(rest, &Wire.take_string/1)
    %__MODULE__{room: room, operators: operators}
  end
end
