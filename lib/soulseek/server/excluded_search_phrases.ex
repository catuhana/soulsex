defmodule Soulseek.Server.ExcludedSearchPhrases do
  @moduledoc """
  The ExcludedSearchPhrases message (server code 160).

  The server sends a list of phrases not allowed on the search network; file
  paths containing them should be excluded from search responses. The client
  sends no such message.
  """

  @behaviour Soulseek.Message

  alias Soulseek.Wire

  @enforce_keys [:phrases]
  defstruct [:phrases]

  @type t :: %__MODULE__{phrases: [String.t()]}

  @impl true
  def encode(%__MODULE__{phrases: phrases}), do: Wire.array(phrases, &Wire.string/1)

  @impl true
  def decode(binary) do
    {phrases, <<>>} = Wire.take_array(binary, &Wire.take_string/1)

    %__MODULE__{phrases: phrases}
  end
end
