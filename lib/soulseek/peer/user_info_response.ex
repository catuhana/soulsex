defmodule Soulseek.Peer.UserInfoResponse do
  @moduledoc """
  The UserInfoResponse message (peer code 16).

  A peer's reply to a UserInfoRequest: a description, an optional picture, the
  total number of uploads, the queue size, and whether a slot is free. The
  upload permission is optional (not sent by SoulseekQt) and is `nil` when
  absent.
  """

  @behaviour Soulseek.Message

  alias Soulseek.{UploadPermission, Wire}

  @enforce_keys [:description, :total_uploads, :queue_size, :slots_free]
  defstruct [:description, :picture, :total_uploads, :queue_size, :slots_free, :upload_permitted]

  @type t :: %__MODULE__{
          description: String.t(),
          picture: binary() | nil,
          total_uploads: non_neg_integer(),
          queue_size: non_neg_integer(),
          slots_free: boolean(),
          upload_permitted: UploadPermission.t() | nil
        }

  @impl true
  def decode(binary) do
    {description, rest} = Wire.take_string(binary)
    {picture, rest} = take_picture(rest)
    {total_uploads, rest} = Wire.take_uint32(rest)
    {queue_size, rest} = Wire.take_uint32(rest)
    {slots_free, rest} = Wire.take_bool(rest)
    upload_permitted = take_permission(rest)

    %__MODULE__{
      description: description,
      picture: picture,
      total_uploads: total_uploads,
      queue_size: queue_size,
      slots_free: slots_free,
      upload_permitted: upload_permitted
    }
  end

  defp take_picture(binary) do
    case Wire.take_bool(binary) do
      {true, rest} -> Wire.take_bytes(rest)
      {false, rest} -> {nil, rest}
    end
  end

  defp take_permission(<<>>), do: nil

  defp take_permission(binary) do
    {value, <<>>} = Wire.take_uint32(binary)

    UploadPermission.from_wire(value)
  end
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Peer.UserInfoResponse do
  alias Soulseek.{UploadPermission, Wire}

  def encode(%Soulseek.Peer.UserInfoResponse{} = struct) do
    [
      Wire.string(struct.description),
      encode_picture(struct.picture),
      Wire.uint32(struct.total_uploads),
      Wire.uint32(struct.queue_size),
      Wire.bool(struct.slots_free),
      encode_permission(struct.upload_permitted)
    ]
  end

  defp encode_picture(nil), do: Wire.bool(false)
  defp encode_picture(picture), do: [Wire.bool(true), Wire.bytes(picture)]

  defp encode_permission(nil), do: []

  defp encode_permission(permission),
    do:
      permission
      |> UploadPermission.to_wire()
      |> Wire.uint32()
end
