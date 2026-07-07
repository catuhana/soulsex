defmodule Soulseek.LoginRejectionReason do
  @moduledoc false

  @type t ::
          :invalid_username
          | :empty_password
          | :invalid_password
          | :invalid_version
          | :server_full
          | :server_private

  @spec to_wire(t()) :: String.t()
  def to_wire(:invalid_username), do: "INVALIDUSERNAME"
  def to_wire(:empty_password), do: "EMPTYPASSWORD"
  def to_wire(:invalid_password), do: "INVALIDPASS"
  def to_wire(:invalid_version), do: "INVALIDVERSION"
  def to_wire(:server_full), do: "SVRFULL"
  def to_wire(:server_private), do: "SVRPRIVATE"

  @spec from_wire(String.t()) :: t()
  def from_wire("INVALIDUSERNAME"), do: :invalid_username
  def from_wire("EMPTYPASSWORD"), do: :empty_password
  def from_wire("INVALIDPASS"), do: :invalid_password
  def from_wire("INVALIDVERSION"), do: :invalid_version
  def from_wire("SVRFULL"), do: :server_full
  def from_wire("SVRPRIVATE"), do: :server_private
end
