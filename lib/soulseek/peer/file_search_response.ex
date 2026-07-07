defmodule Soulseek.Peer.FileSearchResponse do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.SharedFile
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
          results: [SharedFile.t()],
          slot_free: boolean(),
          avg_speed: non_neg_integer(),
          queue_length: non_neg_integer(),
          private_results: [SharedFile.t()]
        }

  @impl true
  def decode(binary) do
    data = Wire.decompress(binary)
    {username, rest} = Wire.take_string(data)
    {token, rest} = Wire.take_uint32(rest)
    {results, rest} = Wire.take_array(rest, &SharedFile.take/1)
    {slot_free, rest} = Wire.take_bool(rest)
    {avg_speed, rest} = Wire.take_uint32(rest)
    {queue_length, rest} = Wire.take_uint32(rest)
    {0, rest} = Wire.take_uint32(rest)
    {private_results, <<>>} = Wire.take_array(rest, &SharedFile.take/1)

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

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.FileSearchResponse do
  alias Soulseek.{SharedFile, Wire}

  def encode(%Soulseek.Peer.FileSearchResponse{} = struct),
    do:
      Wire.compress([
        Wire.string(struct.username),
        Wire.uint32(struct.token),
        Wire.array(struct.results, &SharedFile.encode/1),
        Wire.bool(struct.slot_free),
        Wire.uint32(struct.avg_speed),
        Wire.uint32(struct.queue_length),
        Wire.uint32(0),
        Wire.array(struct.private_results, &SharedFile.encode/1)
      ])
end
