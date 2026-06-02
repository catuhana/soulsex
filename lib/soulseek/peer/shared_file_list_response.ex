defmodule Soulseek.Peer.SharedFileListResponse do
  @moduledoc """
  The SharedFileListResponse message (peer code 5).

  A peer's reply to a SharedFileListRequest: its public and private shared
  directories. The payload is zlib-compressed on the wire, so `encode/1`
  compresses and `decode/1` decompresses.

  An "unknown" `uint32`, which official clients always set to `0`, sits between
  the public and private directories; it is written as `0` and asserted to be
  `0`, so it is not stored on the struct.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Peer.Directory
  alias Soulseek.Wire

  @enforce_keys [:directories, :private_directories]
  defstruct [:directories, :private_directories]

  @type t :: %__MODULE__{
          directories: [Directory.t()],
          private_directories: [Directory.t()]
        }

  @impl true
  def encode(%__MODULE__{} = struct) do
    Wire.compress([
      Wire.array(struct.directories, &Directory.encode/1),
      Wire.uint32(0),
      Wire.array(struct.private_directories, &Directory.encode/1)
    ])
  end

  @impl true
  def decode(binary) do
    data = Wire.decompress(binary)
    {directories, rest} = Wire.take_array(data, &Directory.take/1)
    {0, rest} = Wire.take_uint32(rest)
    {private_directories, <<>>} = Wire.take_array(rest, &Directory.take/1)

    %__MODULE__{directories: directories, private_directories: private_directories}
  end
end
