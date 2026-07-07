defmodule Soulseek.Server.UserJoinedRoom do
  @moduledoc false

  alias Soulseek.UserStatusCode

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
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.UserJoinedRoom do
  alias Soulseek.{UserStatusCode, Wire}

  def encode(%Soulseek.Server.UserJoinedRoom{} = struct),
    do: [
      Wire.string(struct.room),
      Wire.string(struct.username),
      struct.status
      |> UserStatusCode.to_wire()
      |> Wire.uint32(),
      Wire.uint32(struct.avg_speed),
      Wire.uint32(struct.upload_num),
      Wire.uint32(struct.unknown),
      Wire.uint32(struct.files),
      Wire.uint32(struct.dirs),
      Wire.uint32_bool(struct.slots_full),
      Wire.string(struct.country_code)
    ]
end
