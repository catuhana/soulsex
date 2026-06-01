defmodule Soulseek.TransferRejection do
  @moduledoc "Reasons a peer gives for rejecting a file transfer."

  @typedoc """
  Wire strings are matched exactly; note the ones that end with a dot.

  - `:banned` - Peer is banned (`"Banned"`)
  - `:cancelled` - Transfer was cancelled by the peer (`"Cancelled"`)
  - `:complete` - Transfer is already complete (`"Complete"`)
  - `:file_not_shared` - File is not shared by the peer (`"File not shared."`)
  - `:file_read_error` - There was an error reading the file (`"File read error."`)
  - `:pending_shutdown` - The peer is pending shutdown (`"Pending shutdown."`)
  - `:queued` - The transfer is queued (`"Queued"`)
  - `:too_many_files` - The peer has too many files shared (`"Too many files"`)
  - `:too_many_megabytes` - The peer has too many megabytes shared (`"Too many megabytes"`)
  """
  @type t ::
          :banned
          | :cancelled
          | :complete
          | :file_not_shared
          | :file_read_error
          | :pending_shutdown
          | :queued
          | :too_many_files
          | :too_many_megabytes

  @spec to_wire(t()) :: String.t()
  def to_wire(:banned), do: "Banned"
  def to_wire(:cancelled), do: "Cancelled"
  def to_wire(:complete), do: "Complete"
  def to_wire(:file_not_shared), do: "File not shared."
  def to_wire(:file_read_error), do: "File read error."
  def to_wire(:pending_shutdown), do: "Pending shutdown."
  def to_wire(:queued), do: "Queued"
  def to_wire(:too_many_files), do: "Too many files"
  def to_wire(:too_many_megabytes), do: "Too many megabytes"

  @spec from_wire(String.t()) :: t()
  def from_wire("Banned"), do: :banned
  def from_wire("Cancelled"), do: :cancelled
  def from_wire("Complete"), do: :complete
  def from_wire("File not shared."), do: :file_not_shared
  def from_wire("File read error."), do: :file_read_error
  def from_wire("Pending shutdown."), do: :pending_shutdown
  def from_wire("Queued"), do: :queued
  def from_wire("Too many files"), do: :too_many_files
  def from_wire("Too many megabytes"), do: :too_many_megabytes
end
