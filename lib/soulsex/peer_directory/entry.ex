defmodule Soulsex.PeerDirectory.Entry do
  @moduledoc """
  A directory entry for a client (peer), holding either a `Pending` or `Connected`,
  based on whether they have yet sent a `SetWaitPort` message.
  """

  alias Soulsex.PeerDirectory.Entry.{Connected, Pending}

  @type t :: Connected.t() | Pending.t()
end
