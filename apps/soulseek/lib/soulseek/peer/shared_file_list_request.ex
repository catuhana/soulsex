defmodule Soulseek.Peer.SharedFileListRequest do
  @moduledoc """
  The SharedFileListRequest message (peer code 4).

  An empty message asking a peer for its list of shared files. The peer replies
  with a `Soulseek.Peer.SharedFileListResponse`.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def encode(%__MODULE__{}), do: []

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end
