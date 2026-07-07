defmodule Soulseek.Peer.SharedFileListResponse do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.SharedDirectory
  alias Soulseek.Wire

  @enforce_keys [:directories, :private_directories]
  defstruct [:directories, :private_directories]

  @type t :: %__MODULE__{
          directories: [SharedDirectory.t()],
          private_directories: [SharedDirectory.t()]
        }

  @impl true
  def decode(binary) do
    data = Wire.decompress(binary)
    {directories, rest} = Wire.take_array(data, &SharedDirectory.take/1)
    {0, rest} = Wire.take_uint32(rest)
    {private_directories, <<>>} = Wire.take_array(rest, &SharedDirectory.take/1)

    %__MODULE__{directories: directories, private_directories: private_directories}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.SharedFileListResponse do
  alias Soulseek.{SharedDirectory, Wire}

  def encode(%Soulseek.Peer.SharedFileListResponse{} = struct),
    do:
      Wire.compress([
        Wire.array(struct.directories, &SharedDirectory.encode/1),
        Wire.uint32(0),
        Wire.array(struct.private_directories, &SharedDirectory.encode/1)
      ])
end
