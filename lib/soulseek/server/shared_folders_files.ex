defmodule Soulseek.Server.SharedFoldersFiles do
  @moduledoc """
  The SharedFoldersFiles message (server code 35).

  The client sends the number of folders and files it shares. The server sends
  no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:dirs, :files]
  defstruct [:dirs, :files]

  @type t :: %__MODULE__{dirs: non_neg_integer(), files: non_neg_integer()}

  @impl true
  def encode(%__MODULE__{dirs: dirs, files: files}), do: [Wire.uint32(dirs), Wire.uint32(files)]

  @impl true
  def decode(binary) do
    {dirs, rest} = Wire.take_uint32(binary)
    {files, <<>>} = Wire.take_uint32(rest)

    %__MODULE__{dirs: dirs, files: files}
  end
end
