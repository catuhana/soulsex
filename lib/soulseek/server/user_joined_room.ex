defmodule Soulseek.Server.UserJoinedRoom do
  @moduledoc """
  The UserJoinedRoom message (server code 16).

  The server tells us someone has joined a room we're in, along with that user's
  status and stats. The client sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.{UserStatusCode, Wire}

  @enforce_keys [
    :room,
    :username,
    :status,
    :avg_speed,
    :upload_num,
    :unknown,
    :files,
    :dirs,
    :slots_full,
    :country_code
  ]
  defstruct [
    :room,
    :username,
    :status,
    :avg_speed,
    :upload_num,
    :unknown,
    :files,
    :dirs,
    :slots_full,
    :country_code
  ]

  @type t :: %__MODULE__{
          room: String.t(),
          username: String.t(),
          status: UserStatusCode.t(),
          avg_speed: non_neg_integer(),
          upload_num: non_neg_integer(),
          unknown: non_neg_integer(),
          files: non_neg_integer(),
          dirs: non_neg_integer(),
          slots_full: boolean(),
          country_code: String.t()
        }

  @impl true
  def encode(%__MODULE__{} = struct),
    do: [
      Wire.string(struct.room),
      Wire.string(struct.username),
      struct.status |> UserStatusCode.to_wire() |> Wire.uint32(),
      Wire.uint32(struct.avg_speed),
      Wire.uint32(struct.upload_num),
      Wire.uint32(struct.unknown),
      Wire.uint32(struct.files),
      Wire.uint32(struct.dirs),
      Wire.uint32_bool(struct.slots_full),
      Wire.string(struct.country_code)
    ]

  @impl true
  def decode(binary) do
    {room, rest} = Wire.take_string(binary)
    {username, rest} = Wire.take_string(rest)
    {status, rest} = Wire.take_uint32(rest)
    {avg_speed, rest} = Wire.take_uint32(rest)
    {upload_num, rest} = Wire.take_uint32(rest)
    {unknown, rest} = Wire.take_uint32(rest)
    {files, rest} = Wire.take_uint32(rest)
    {dirs, rest} = Wire.take_uint32(rest)
    {slots_full, rest} = Wire.take_uint32_bool(rest)
    {country_code, <<>>} = Wire.take_string(rest)

    %__MODULE__{
      room: room,
      username: username,
      status: UserStatusCode.from_wire(status),
      avg_speed: avg_speed,
      upload_num: upload_num,
      unknown: unknown,
      files: files,
      dirs: dirs,
      slots_full: slots_full,
      country_code: country_code
    }
  end
end
