defmodule Soulseek.Server.SetWaitPort do
  @moduledoc """
  The SetWaitPort message (server code 2).

  The client sends this to indicate the port it listens on for peer connections
  (2234 by default). Some clients (e.g. SoulseekQt) also obfuscate peer messages
  and supply an obfuscation type and obfuscated port; the server sends no reply.
  """

  @behaviour Soulseek.Message

  alias Soulseek.{ObfuscationType, Wire}

  defmodule Obfuscation do
    @moduledoc "Optional peer-message obfuscation settings for a `SetWaitPort` message."

    @enforce_keys [:type, :port]
    defstruct [:type, :port]

    @type t :: %__MODULE__{
            type: ObfuscationType.t(),
            port: 0..65_535
          }
  end

  @enforce_keys [:port]
  defstruct [:port, :obfuscation]

  @type t :: %__MODULE__{
          port: 0..65_535,
          obfuscation: Obfuscation.t() | nil
        }

  @impl true
  def encode(%__MODULE__{port: port, obfuscation: nil}) do
    Wire.uint32(port)
  end

  @impl true
  def encode(%__MODULE__{
        port: port,
        obfuscation: %Obfuscation{type: type, port: obfuscated_port}
      }) do
    [
      Wire.uint32(port),
      Wire.uint32(ObfuscationType.to_wire(type)),
      Wire.uint32(obfuscated_port)
    ]
  end

  @impl true
  def decode(<<port::little-32>>), do: %__MODULE__{port: port}

  @impl true
  def decode(<<port::little-32, obfuscation_type::little-32, obfuscated_port::little-32>>) do
    %__MODULE__{
      port: port,
      obfuscation: %Obfuscation{
        type: ObfuscationType.from_wire(obfuscation_type),
        port: obfuscated_port
      }
    }
  end
end
