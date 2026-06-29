defmodule Soulseek.Peer.UploadResponse do
  @moduledoc """
  The TransferResponse message, upload variant (peer code 41).

  Replies to a `TransferRequest`, either allowing the upload or giving a
  rejection reason. The `reason` is present only when not allowed.
  """

  @behaviour Soulseek.Message

  alias Soulseek.{TransferRejection, Wire}

  @enforce_keys [:token, :allowed]
  defstruct [:token, :allowed, :reason]

  @type t :: %__MODULE__{
          token: non_neg_integer(),
          allowed: boolean(),
          reason: TransferRejection.t() | nil
        }

  @impl true
  def encode(%__MODULE__{token: token, allowed: true}), do: [Wire.uint32(token), Wire.bool(true)]

  def encode(%__MODULE__{token: token, allowed: false, reason: reason}),
    do: [
      Wire.uint32(token),
      Wire.bool(false),
      reason |> TransferRejection.to_wire() |> Wire.string()
    ]

  @impl true
  def decode(binary) do
    {token, rest} = Wire.take_uint32(binary)
    {allowed, rest} = Wire.take_bool(rest)

    decode_reason(token, allowed, rest)
  end

  defp decode_reason(token, true, <<>>), do: %__MODULE__{token: token, allowed: true, reason: nil}

  defp decode_reason(token, false, rest) do
    {reason, <<>>} = Wire.take_string(rest)

    %__MODULE__{token: token, allowed: false, reason: TransferRejection.from_wire(reason)}
  end
end
