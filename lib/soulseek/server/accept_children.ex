defmodule Soulseek.Server.AcceptChildren do
  @moduledoc false

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:accept]
  defstruct [:accept]

  @type t :: %__MODULE__{accept: boolean()}

  @impl true
  def decode(binary) do
    {accept, <<>>} = Wire.take_bool(binary)

    %__MODULE__{accept: accept}
  end
end
