defmodule Soulseek.Peer.FolderContentsResponse do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.SharedDirectory
  alias Soulseek.Wire

  @enforce_keys [:token, :folder, :folders]
  defstruct [:token, :folder, :folders]

  @type t :: %__MODULE__{
          token: non_neg_integer(),
          folder: String.t(),
          folders: [SharedDirectory.t()]
        }

  @impl true
  def decode(binary) do
    data = Wire.decompress(binary)
    {token, rest} = Wire.take_uint32(data)
    {folder, rest} = Wire.take_string(rest)
    {folders, <<>>} = Wire.take_array(rest, &SharedDirectory.take/1)

    %__MODULE__{token: token, folder: folder, folders: folders}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.FolderContentsResponse do
  alias Soulseek.{SharedDirectory, Wire}

  def encode(%Soulseek.Peer.FolderContentsResponse{} = struct),
    do:
      Wire.compress([
        Wire.uint32(struct.token),
        Wire.string(struct.folder),
        Wire.array(struct.folders, &SharedDirectory.encode/1)
      ])
end
