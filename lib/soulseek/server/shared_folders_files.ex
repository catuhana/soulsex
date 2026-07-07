defmodule Soulseek.Server.SharedFoldersFiles do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:dirs, :files]
  defstruct [:dirs, :files]

  @type t :: %__MODULE__{dirs: non_neg_integer(), files: non_neg_integer()}

  @impl true
  def decode(binary) do
    {dirs, rest} = Wire.take_uint32(binary)
    {files, <<>>} = Wire.take_uint32(rest)

    %__MODULE__{dirs: dirs, files: files}
  end
end
