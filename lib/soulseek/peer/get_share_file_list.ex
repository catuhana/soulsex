defmodule Soulseek.Peer.GetShareFileList do
  @moduledoc false

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.GetShareFileList do
  def encode(%Soulseek.Peer.GetShareFileList{}), do: []
end
