defmodule Soulseek.Peer.UploadDenied do
  @moduledoc """
  The UploadDenied message (peer code 50).

  Rejects a `QueueUpload` attempt or a previously queued file. Carries the
  filename and a rejection reason, in both directions.
  """

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
