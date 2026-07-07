defmodule Soulseek.Server.GetUserStats do
  @moduledoc false

  alias Soulseek.Wire

  defmodule Request do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:username]
    defstruct [:username]

    @type t :: %__MODULE__{username: String.t()}

    @impl true
    def decode(binary) do
      {username, <<>>} = Wire.take_string(binary)

      %__MODULE__{username: username}
    end
  end

  defmodule Response do
    @moduledoc false

    @behaviour Soulseek.Message

    @enforce_keys [:username, :avg_speed, :upload_num, :unknown, :files, :dirs]
    defstruct [:username, :avg_speed, :upload_num, :unknown, :files, :dirs]

    @type t :: %__MODULE__{
            username: String.t(),
            avg_speed: non_neg_integer(),
            upload_num: non_neg_integer(),
            unknown: non_neg_integer(),
            files: non_neg_integer(),
            dirs: non_neg_integer()
          }

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {avg_speed, rest} = Wire.take_uint32(rest)
      {upload_num, rest} = Wire.take_uint32(rest)
      {unknown, rest} = Wire.take_uint32(rest)
      {files, rest} = Wire.take_uint32(rest)
      {dirs, <<>>} = Wire.take_uint32(rest)

      %__MODULE__{
        username: username,
        avg_speed: avg_speed,
        upload_num: upload_num,
        unknown: unknown,
        files: files,
        dirs: dirs
      }
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GetUserStats.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.GetUserStats.Request{username: username}), do: Wire.string(username)
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.GetUserStats.Response do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.GetUserStats.Response{} = struct),
    do: [
      Wire.string(struct.username),
      Wire.uint32(struct.avg_speed),
      Wire.uint32(struct.upload_num),
      Wire.uint32(struct.unknown),
      Wire.uint32(struct.files),
      Wire.uint32(struct.dirs)
    ]
end
