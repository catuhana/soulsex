defmodule Soulseek.Peer.Codes do
  @moduledoc """
  Registry of peer message codes mapped to their message modules.

  The code keys a message's namespace module; resolving the `Request`/`Response`
  variant for a given direction is the caller's concern.
  """

  @codes %{
    4 => Soulseek.Peer.SharedFileListRequest,
    5 => Soulseek.Peer.SharedFileListResponse,
    9 => Soulseek.Peer.FileSearchResponse,
    15 => Soulseek.Peer.UserInfoRequest,
    16 => Soulseek.Peer.UserInfoResponse,
    36 => Soulseek.Peer.FolderContentsRequest,
    37 => Soulseek.Peer.FolderContentsResponse,
    40 => Soulseek.Peer.TransferRequest,
    41 => Soulseek.Peer.UploadResponse,
    43 => Soulseek.Peer.QueueUpload,
    44 => Soulseek.Peer.PlaceInQueueResponse,
    46 => Soulseek.Peer.UploadFailed,
    50 => Soulseek.Peer.UploadDenied,
    51 => Soulseek.Peer.PlaceInQueueRequest
  }

  @modules Map.new(@codes, fn {code, module} -> {module, code} end)

  @spec module(non_neg_integer()) :: module() | nil
  def module(code), do: Map.get(@codes, code)

  @spec code(module()) :: non_neg_integer() | nil
  def code(module), do: Map.get(@modules, module)

  @spec modules :: [module()]
  def modules, do: Map.keys(@modules)
end
