defmodule Soulseek.Server.WatchUser do
  @moduledoc """
  The WatchUser message (server code 5).

  The client sends a `Request` with a username to be kept updated about that
  user's status; the server replies with a `Response` carrying the user's
  current status and stats when the user exists.
  """

  alias Soulseek.{UserStatusCode, Wire}

  defmodule Request do
    @moduledoc "A request to watch a user, sent by the client to the server."

    @behaviour Soulseek.Message

    @enforce_keys [:username]
    defstruct [:username]

    @type t :: %__MODULE__{username: String.t()}

    @impl true
    def encode(%__MODULE__{username: username}), do: Wire.string(username)

    @impl true
    def decode(binary) do
      {username, <<>>} = Wire.take_string(binary)

      %__MODULE__{username: username}
    end
  end

  defmodule Info do
    @moduledoc "A watched user's status and stats, present when the user exists."

    @enforce_keys [:status, :avg_speed, :upload_num, :unknown, :files, :dirs]
    defstruct [:status, :avg_speed, :upload_num, :unknown, :files, :dirs, :country_code]

    @type t :: %__MODULE__{
            status: UserStatusCode.t(),
            avg_speed: non_neg_integer(),
            upload_num: non_neg_integer(),
            unknown: non_neg_integer(),
            files: non_neg_integer(),
            dirs: non_neg_integer(),
            country_code: String.t() | nil
          }
  end

  defmodule Response do
    @moduledoc "A watched user's information, sent by the server to the client."

    @behaviour Soulseek.Message

    alias Soulseek.Server.WatchUser.Info

    @enforce_keys [:username]
    defstruct [:username, :info]

    @type t :: %__MODULE__{
            username: String.t(),
            info: Info.t() | nil
          }

    @impl true
    def encode(%__MODULE__{username: username, info: nil}),
      do: [Wire.string(username), Wire.bool(false)]

    def encode(%__MODULE__{username: username, info: %Info{} = info}),
      do: [
        Wire.string(username),
        Wire.bool(true),
        info.status |> UserStatusCode.to_wire() |> Wire.uint32(),
        Wire.uint32(info.avg_speed),
        Wire.uint32(info.upload_num),
        Wire.uint32(info.unknown),
        Wire.uint32(info.files),
        Wire.uint32(info.dirs),
        encode_country(info.status, info.country_code)
      ]

    defp encode_country(status, country_code) when status in [:away, :online],
      do: Wire.string(country_code)

    defp encode_country(:offline, _country_code), do: []

    @impl true
    def decode(binary) do
      {username, rest} = Wire.take_string(binary)
      {exists, rest} = Wire.take_bool(rest)

      decode_info(username, exists, rest)
    end

    defp decode_info(username, false, <<>>), do: %__MODULE__{username: username, info: nil}

    defp decode_info(username, true, rest) do
      {status, rest} = Wire.take_uint32(rest)
      {avg_speed, rest} = Wire.take_uint32(rest)
      {upload_num, rest} = Wire.take_uint32(rest)
      {unknown, rest} = Wire.take_uint32(rest)
      {files, rest} = Wire.take_uint32(rest)
      {dirs, rest} = Wire.take_uint32(rest)
      status = UserStatusCode.from_wire(status)

      %__MODULE__{
        username: username,
        info: %Info{
          status: status,
          avg_speed: avg_speed,
          upload_num: upload_num,
          unknown: unknown,
          files: files,
          dirs: dirs,
          country_code: decode_country(status, rest)
        }
      }
    end

    defp decode_country(status, rest) when status in [:away, :online] do
      {country_code, <<>>} = Wire.take_string(rest)

      country_code
    end

    defp decode_country(:offline, <<>>), do: nil
  end
end
