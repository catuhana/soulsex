defmodule Soulseek.Peer.FolderContentsResponse do
  @moduledoc """
  The FolderContentsResponse message (peer code 37).

  A peer's reply to a FolderContentsRequest: the request token, the requested
  folder, and the folders (with all subfolders) it contains. The payload is
  zlib-compressed on the wire, so `encode/1` compresses and `decode/1`
  decompresses.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Peer.Directory
  alias Soulseek.Wire

  @enforce_keys [:token, :folder, :folders]
  defstruct [:token, :folder, :folders]

  @type t :: %__MODULE__{
          token: non_neg_integer(),
          folder: String.t(),
          folders: [Directory.t()]
        }

  @impl true
  def encode(%__MODULE__{} = struct) do
    Wire.compress([
      Wire.uint32(struct.token),
      Wire.string(struct.folder),
      Wire.array(struct.folders, &Directory.encode/1)
    ])
  end

  @impl true
  def decode(binary) do
    data = Wire.decompress(binary)
    {token, rest} = Wire.take_uint32(data)
    {folder, rest} = Wire.take_string(rest)
    {folders, <<>>} = Wire.take_array(rest, &Directory.take/1)

    %__MODULE__{token: token, folder: folder, folders: folders}
  end
end
