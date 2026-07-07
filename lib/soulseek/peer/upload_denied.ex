defmodule Soulseek.Peer.UploadDenied do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.{TransferRejection, Wire}

  @enforce_keys [:filename, :reason]
  defstruct [:filename, :reason]

  @type t :: %__MODULE__{filename: String.t(), reason: TransferRejection.t()}

  @impl true
  def decode(binary) do
    {filename, rest} = Wire.take_string(binary)
    {reason, <<>>} = Wire.take_string(rest)

    %__MODULE__{filename: filename, reason: TransferRejection.from_wire(reason)}
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.UploadDenied do
  alias Soulseek.{TransferRejection, Wire}

  def encode(%Soulseek.Peer.UploadDenied{filename: filename, reason: reason}),
    do: [
      Wire.string(filename),
      reason
      |> TransferRejection.to_wire()
      |> Wire.string()
    ]
end
