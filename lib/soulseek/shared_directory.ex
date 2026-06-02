defmodule Soulseek.SharedDirectory do
  @moduledoc """
  A directory entry shared by peer file listings (SharedFileList and
  FolderContents responses): a name and the list of `Soulseek.SharedFile`
  entries it contains.
  """

  alias Soulseek.SharedFile
  alias Soulseek.Wire

  @enforce_keys [:name, :files]
  defstruct [:name, :files]

  @type t :: %__MODULE__{name: String.t(), files: [SharedFile.t()]}

  @spec encode(t()) :: iodata()
  def encode(%__MODULE__{} = directory) do
    [Wire.string(directory.name), Wire.array(directory.files, &SharedFile.encode/1)]
  end

  @spec take(binary()) :: {t(), binary()}
  def take(binary) do
    {name, rest} = Wire.take_string(binary)
    {files, rest} = Wire.take_array(rest, &SharedFile.take/1)
    {%__MODULE__{name: name, files: files}, rest}
  end
end
