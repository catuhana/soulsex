defmodule Soulseek.Peer.Directory do
  @moduledoc """
  A directory entry shared by peer file listings (SharedFileList and
  FolderContents responses): a name and the list of `Soulseek.Peer.File`
  entries it contains.
  """

  alias Soulseek.Peer.File
  alias Soulseek.Wire

  @enforce_keys [:name, :files]
  defstruct [:name, :files]

  @type t :: %__MODULE__{name: String.t(), files: [File.t()]}

  @doc "Encodes a directory entry as iodata."
  @spec encode(t()) :: iodata()
  def encode(%__MODULE__{} = directory) do
    [Wire.string(directory.name), Wire.array(directory.files, &File.encode/1)]
  end

  @doc "Decodes one directory entry, returning `{directory, rest}`. Inverse of `encode/1`."
  @spec take(binary()) :: {t(), binary()}
  def take(binary) do
    {name, rest} = Wire.take_string(binary)
    {files, rest} = Wire.take_array(rest, &File.take/1)
    {%__MODULE__{name: name, files: files}, rest}
  end
end
