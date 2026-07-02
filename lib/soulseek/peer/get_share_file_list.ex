defmodule Soulseek.Peer.GetShareFileList do
  @moduledoc """
  The GetShareFileList message (peer code 4).

  An empty message asking a peer for its list of shared files. The peer replies
  with a `Soulseek.Peer.SharedFileListResponse`.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.GetShareFileList do
  def encode(%Soulseek.Peer.GetShareFileList{}), do: []
end
