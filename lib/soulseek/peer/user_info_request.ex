defmodule Soulseek.Peer.UserInfoRequest do
  @moduledoc """
  The UserInfoRequest message (peer code 15).

  An empty message asking a peer for its user information. The peer replies with
  a `Soulseek.Peer.UserInfoResponse`.
  """

  @behaviour Soulseek.Message

  defstruct []

  @type t :: %__MODULE__{}

  @impl true
  def decode(<<>>), do: %__MODULE__{}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.UserInfoRequest do
  def encode(%Soulseek.Peer.UserInfoRequest{}), do: []
end
