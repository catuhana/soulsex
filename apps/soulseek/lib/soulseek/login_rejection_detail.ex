defmodule Soulseek.LoginRejectionDetail do
  @moduledoc """
  Detail accompanying an `:invalid_username` `Soulseek.LoginRejectionReason`.
  """

  @typedoc """
  - `:nick_empty` - Nick empty (`"Nick empty."`)
  - `:nick_too_long` - Nick too long, maximum 30 characters allowed (`"Nick too long."`)
  - `:nick_invalid_characters` - Invalid characters in nick, only printable ASCII characters allowed (`"Invalid characters in nick."`)
  - `:nick_leading_or_trailing_space` - No leading and trailing spaces allowed (`"No leading and trailing spaces allowed in nick."`)
  """
  @type t ::
          :nick_empty
          | :nick_too_long
          | :nick_invalid_characters
          | :nick_leading_or_trailing_space

  @spec to_wire(t()) :: String.t()
  def to_wire(:nick_empty), do: "Nick empty."
  def to_wire(:nick_too_long), do: "Nick too long."
  def to_wire(:nick_invalid_characters), do: "Invalid characters in nick."

  def to_wire(:nick_leading_or_trailing_space),
    do: "No leading and trailing spaces allowed in nick."

  @spec from_wire(String.t()) :: t()
  def from_wire("Nick empty."), do: :nick_empty
  def from_wire("Nick too long."), do: :nick_too_long
  def from_wire("Invalid characters in nick."), do: :nick_invalid_characters

  def from_wire("No leading and trailing spaces allowed in nick."),
    do: :nick_leading_or_trailing_space
end
