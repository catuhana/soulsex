defmodule Soulseek do
  @moduledoc "Documentation for `Soulseek`."

  @doc """
  Greet the input `name`.

  ## Examples

      iex> Soulseek.greet("World")
      "Hello, World!"

  """
  @spec greet(String.t()) :: String.t()
  def greet(name), do: "Hello, #{name}!"
end
