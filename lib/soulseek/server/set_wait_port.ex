defmodule Soulseek.Server.SetWaitPort do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.ObfuscationType

  @enforce_keys [:port]
  defstruct [:port, :obfuscation_type, :obfuscated_port]

  @type t :: %__MODULE__{
          port: :inet.port_number(),
          obfuscation_type: ObfuscationType.t() | nil,
          obfuscated_port: :inet.port_number() | nil
        }

  @impl true
  def decode(<<port::little-32>>), do: %__MODULE__{port: port}

  def decode(<<port::little-32, obfuscation_type::little-32, obfuscated_port::little-32>>),
    do: %__MODULE__{
      port: port,
      obfuscation_type: ObfuscationType.from_wire(obfuscation_type),
      obfuscated_port: obfuscated_port
    }
end
