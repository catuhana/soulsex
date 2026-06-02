defmodule Soulseek.Peer.FileSearchResponse do
  @moduledoc """
  The FileSearchResponse message (peer code 9).

  A peer's reply to a file search, carrying the responding username, the search
  token, the matching results, whether an upload slot is free, the average
  upload speed, the queue length, and any privately shared results. The payload
  is zlib-compressed on the wire, so `encode/1` compresses and `decode/1`
  decompresses.

  An "unknown" `uint32`, which official clients always set to `0`, sits between
  the queue length and the private results; it is written as `0` and asserted to
  be `0`, so it is not stored on the struct.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Peer.File
  alias Soulseek.Wire

  @enforce_keys [
    :username,
    :token,
    :results,
    :slot_free,
    :avg_speed,
    :queue_length,
    :private_results
  ]
  defstruct [:username, :token, :results, :slot_free, :avg_speed, :queue_length, :private_results]

  @type t :: %__MODULE__{
          username: String.t(),
          token: non_neg_integer(),
          results: [File.t()],
          slot_free: boolean(),
          avg_speed: non_neg_integer(),
          queue_length: non_neg_integer(),
          private_results: [File.t()]
        }

  @impl true
  def encode(%__MODULE__{} = struct) do
    Wire.compress([
      Wire.string(struct.username),
      Wire.uint32(struct.token),
      Wire.array(struct.results, &File.encode/1),
      Wire.bool(struct.slot_free),
      Wire.uint32(struct.avg_speed),
      Wire.uint32(struct.queue_length),
      Wire.uint32(0),
      Wire.array(struct.private_results, &File.encode/1)
    ])
  end

  @impl true
  def decode(binary) do
    data = Wire.decompress(binary)
    {username, rest} = Wire.take_string(data)
    {token, rest} = Wire.take_uint32(rest)
    {results, rest} = Wire.take_array(rest, &File.take/1)
    {slot_free, rest} = Wire.take_bool(rest)
    {avg_speed, rest} = Wire.take_uint32(rest)
    {queue_length, rest} = Wire.take_uint32(rest)
    {0, rest} = Wire.take_uint32(rest)
    {private_results, <<>>} = Wire.take_array(rest, &File.take/1)

    %__MODULE__{
      username: username,
      token: token,
      results: results,
      slot_free: slot_free,
      avg_speed: avg_speed,
      queue_length: queue_length,
      private_results: private_results
    }
  end
end
