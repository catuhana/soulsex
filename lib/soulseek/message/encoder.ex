defprotocol Soulseek.Message.Encoder do
  alias Soulseek.Message

  @spec encode(Message.t()) :: iodata()
  def encode(message)
end
