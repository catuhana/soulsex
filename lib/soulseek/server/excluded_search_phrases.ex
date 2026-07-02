defmodule Soulseek.Server.ExcludedSearchPhrases do
  @moduledoc """
  The ExcludedSearchPhrases message (server code 160).

  The server sends a list of phrases not allowed on the search network; file
  paths containing them should be excluded from search responses. The client
  sends no such message.
  """

  @enforce_keys [:phrases]
  defstruct [:phrases]

  @type t :: %__MODULE__{phrases: [String.t()]}
end

defimpl Soulseek.Message.Encoder, for: Soulseek.Server.ExcludedSearchPhrases do
  alias Soulseek.Wire

  def encode(%Soulseek.Server.ExcludedSearchPhrases{phrases: phrases}),
    do: Wire.array(phrases, &Wire.string/1)
end
