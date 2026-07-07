defmodule Soulseek.Server.SetStatus do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.UserStatusCode

  @enforce_keys [:status]
  defstruct [:status]

  @type t :: %__MODULE__{status: UserStatusCode.t()}

  @impl true
  def decode(<<status::little-signed-32>>),
    do: %__MODULE__{status: UserStatusCode.from_wire(status)}
end
