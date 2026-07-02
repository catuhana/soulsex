defmodule Soulseek.Server.JoinRoom do
  @moduledoc """
  The JoinRoom message (server code 14).

  The client sends a `Request` to join a room (creating it if it doesn't exist);
  the server replies with a `Response` listing the room's users with their
  statuses and stats, plus owner and operators for private rooms.
  """

  alias Soulseek.{UserStatusCode, Wire}

  defmodule Request do
    @moduledoc "A request to join or create a room, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:room, :private]
    defstruct [:room, :private]

    @type t :: %__MODULE__{room: String.t(), private: boolean()}

    @impl true
    def decode(binary) do
      {room, rest} = Wire.take_string(binary)
      {private, <<>>} = Wire.take_uint32_bool(rest)

      %__MODULE__{room: room, private: private}
    end
  end

  defmodule Response do
    @moduledoc "The users of a joined room, sent by the server to the client."

    @behaviour Soulseek.Message

    defmodule User do
      @moduledoc "A user present in a joined room."

      @enforce_keys [
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

    defmodule Private do
      @moduledoc "The owner and operators of a private room."

      @enforce_keys [:owner, :operators]
      defstruct [:owner, :operators]

      @type t :: %__MODULE__{owner: String.t(), operators: [String.t()]}
    end

    @enforce_keys [:room, :users]
    defstruct [:room, :users, :private]

    @type t :: %__MODULE__{
            room: String.t(),
            users: [User.t()],
            private: Private.t() | nil
          }

    @impl true
    def decode(binary) do
      {room, rest} = Wire.take_string(binary)
      {usernames, rest} = Wire.take_array(rest, &Wire.take_string/1)
      {statuses, rest} = Wire.take_array(rest, &take_status/1)
      {stats, rest} = Wire.take_array(rest, &take_stats/1)
      {slots, rest} = Wire.take_array(rest, &Wire.take_uint32_bool/1)
      {countries, rest} = Wire.take_array(rest, &Wire.take_string/1)

      %__MODULE__{
        room: room,
        users: zip_users(usernames, statuses, stats, slots, countries),
        private: decode_private(rest)
      }
    end

    defp take_status(binary) do
      {status, rest} = Wire.take_uint32(binary)

      {UserStatusCode.from_wire(status), rest}
    end

    defp take_stats(binary) do
      {avg_speed, rest} = Wire.take_uint32(binary)
      {upload_num, rest} = Wire.take_uint32(rest)
      {unknown, rest} = Wire.take_uint32(rest)
      {files, rest} = Wire.take_uint32(rest)
      {dirs, rest} = Wire.take_uint32(rest)

      # TODO: Maybe create a custom struct for stats
      # instead of returning a map?
      {%{
         avg_speed: avg_speed,
         upload_num: upload_num,
         unknown: unknown,
         files: files,
         dirs: dirs
       }, rest}
    end

    defp zip_users(usernames, statuses, stats, slots, countries),
      do:
        [usernames, statuses, stats, slots, countries]
        |> Enum.zip()
        |> Enum.map(fn {username, status, stat, slots_full, country_code} ->
          %User{
            username: username,
            status: status,
            avg_speed: stat.avg_speed,
            upload_num: stat.upload_num,
            unknown: stat.unknown,
            files: stat.files,
            dirs: stat.dirs,
            slots_full: slots_full,
            country_code: country_code
          }
        end)

    defp decode_private(<<>>), do: nil

    defp decode_private(rest) do
      {owner, rest} = Wire.take_string(rest)
      {operators, <<>>} = Wire.take_array(rest, &Wire.take_string/1)

      %Private{owner: owner, operators: operators}
    end
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.JoinRoom.Request do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.JoinRoom.Request{room: room, private: private}),
    do: [Wire.string(room), Wire.uint32_bool(private)]
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.JoinRoom.Response do
  alias Soulseek.Server.JoinRoom.Response.Private
  alias Soulseek.{UserStatusCode, Wire}

  def encode(%Soulseek.Server.JoinRoom.Response{room: room, users: users, private: private}),
    do: [
      Wire.string(room),
      Wire.array(users, fn user -> Wire.string(user.username) end),
      Wire.array(users, fn user ->
        user.status
        |> UserStatusCode.to_wire()
        |> Wire.uint32()
      end),
      Wire.array(users, &encode_stats/1),
      Wire.array(users, fn user -> Wire.uint32_bool(user.slots_full) end),
      Wire.array(users, fn user -> Wire.string(user.country_code) end),
      encode_private(private)
    ]

  defp encode_stats(user),
    do: [
      Wire.uint32(user.avg_speed),
      Wire.uint32(user.upload_num),
      Wire.uint32(user.unknown),
      Wire.uint32(user.files),
      Wire.uint32(user.dirs)
    ]

  defp encode_private(nil), do: []

  defp encode_private(%Private{owner: owner, operators: operators}),
    do: [Wire.string(owner), Wire.array(operators, &Wire.string/1)]
end
