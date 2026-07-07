defmodule Soulseek.Server.ExcludedSearchPhrases do
  @moduledoc false

  @enforce_keys [:phrases]
  defstruct [:phrases]

  @type t :: %__MODULE__{phrases: [String.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ExcludedSearchPhrases do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ExcludedSearchPhrases{phrases: phrases}),
    do: Wire.array(phrases, &Wire.string/1)
end
