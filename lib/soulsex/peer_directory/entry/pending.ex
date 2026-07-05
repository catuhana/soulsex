defmodule Soulsex.PeerDirectory.Entry.Pending do
  @moduledoc """
  A peer that has logged in but has not yet sent `SetWaitPort`.

  When a peer is in their `Pending` state, we should still reply
  to messages such as `GetPeerAddress`, but with their port set
  to `0`. This is not documented, but is the behaviour of the
  Nicotine+ client.
  """

  @type t :: %__MODULE__{
          ip: :inet.ip4_address()
        }

  @enforce_keys [:ip]
  defstruct [:ip]
end
