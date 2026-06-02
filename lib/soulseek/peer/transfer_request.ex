defmodule Soulseek.Peer.TransferRequest do
  @moduledoc """
  The TransferRequest message (peer code 40).

  Sent when a peer is ready to start a transfer. Carries the transfer direction,
  a token, and the filename; the file size is present only for uploads
  (direction `:upload`).
  """

  @behaviour Soulseek.Message

  alias Soulseek.{TransferDirection, Wire}

  @enforce_keys [:direction, :token, :filename]
  defstruct [:direction, :token, :filename, :file_size]

  @type t :: %__MODULE__{
          direction: TransferDirection.t(),
          token: non_neg_integer(),
          filename: String.t(),
          file_size: non_neg_integer() | nil
        }

  @impl true
  def encode(%__MODULE__{direction: :upload} = struct) do
    [base(struct), Wire.uint64(struct.file_size)]
  end

  @impl true
  def encode(%__MODULE__{direction: :download} = struct), do: base(struct)

  defp base(%__MODULE__{direction: direction, token: token, filename: filename}) do
    [Wire.uint32(TransferDirection.to_wire(direction)), Wire.uint32(token), Wire.string(filename)]
  end

  @impl true
  def decode(binary) do
    {direction, rest} = Wire.take_uint32(binary)
    {token, rest} = Wire.take_uint32(rest)
    {filename, rest} = Wire.take_string(rest)
    decode_size(TransferDirection.from_wire(direction), token, filename, rest)
  end

  defp decode_size(:upload, token, filename, rest) do
    {file_size, <<>>} = Wire.take_uint64(rest)
    %__MODULE__{direction: :upload, token: token, filename: filename, file_size: file_size}
  end

  defp decode_size(:download, token, filename, <<>>) do
    %__MODULE__{direction: :download, token: token, filename: filename, file_size: nil}
  end
end
