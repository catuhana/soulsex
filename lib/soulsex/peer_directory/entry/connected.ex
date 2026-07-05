defmodule Soulsex.PeerDirectory.Entry.Connected do
  @moduledoc """
  A peer with a known listening port, established via `SetWaitPort`.
  """

  alias Soulseek.ObfuscationType

  @type t :: %__MODULE__{
          ip: :inet.ip4_address(),
          port: :inet.port_number(),
          obfuscation_type: ObfuscationType.t() | nil,
          obfuscated_port: :inet.port_number() | nil
        }

  @enforce_keys [:ip, :port]
  defstruct [:ip, :port, :obfuscation_type, :obfuscated_port]
end
