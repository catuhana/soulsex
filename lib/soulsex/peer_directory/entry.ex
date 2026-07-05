defmodule Soulsex.PeerDirectory.Entry do
  @moduledoc """
  A directory entry for a client (peer), holding either a `Pending` or `Connected`,
  based on whether they have yet sent a `SetWaitPort` message.

  When a peer first logs in, we only know about their IPv4 address as that's
  what's given to us from the `Login` message. If the login message was successfully
  processed and sent to the peer, they send us `SetWaitPort` to tell us what port
  they're listening on (with optional obfuscation related fields). Now we can update
  the entry to `Connected`, and we can use it to send their data to other peers.
  """

  alias Soulsex.PeerDirectory.Entry.{Connected, Pending}

  @type t :: Connected.t() | Pending.t()
end
