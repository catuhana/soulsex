defmodule Soulseek.UploadPermission do
  @moduledoc "Who a user permits to upload to them."

  @typedoc """
  - `:no_one` - No one (`0`)
  - `:everyone` - Everyone (`1`)
  - `:users_in_list` - Users in list (`2`)
  - `:permitted_users` - Permitted users (`3`)
  """
  @type t :: :no_one | :everyone | :users_in_list | :permitted_users

  @spec to_wire(t()) :: 0..3
  def to_wire(:no_one), do: 0
  def to_wire(:everyone), do: 1
  def to_wire(:users_in_list), do: 2
  def to_wire(:permitted_users), do: 3

  @spec from_wire(0..3) :: t()
  def from_wire(0), do: :no_one
  def from_wire(1), do: :everyone
  def from_wire(2), do: :users_in_list
  def from_wire(3), do: :permitted_users
end
