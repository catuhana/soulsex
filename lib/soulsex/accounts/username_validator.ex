defmodule Soulsex.Accounts.UsernameValidator do
  @moduledoc false

  alias Soulseek.LoginRejectionDetail

  @max_length 30

  @spec validate(String.t()) :: :ok | {:error, LoginRejectionDetail.t()}
  def validate(""), do: {:error, :nick_empty}

  def validate(username) do
    cond do
      String.length(username) > @max_length -> {:error, :nick_too_long}
      username != String.trim(username) -> {:error, :nick_leading_or_trailing_space}
      not printable_ascii?(username) -> {:error, :nick_invalid_characters}
      true -> :ok
    end
  end

  defp printable_ascii?(username) do
    username
    |> String.to_charlist()
    |> Enum.all?(&(&1 in 32..126))
  end
end
