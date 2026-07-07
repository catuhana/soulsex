defmodule Soulsex.Accounts do
  @moduledoc false

  require Logger

  import Ecto.Query

  alias Soulseek.{LoginRejectionDetail, LoginRejectionReason}
  alias Soulsex.{Repo, UsernameValidator}
  alias Soulsex.Schema.User

  @type login_error ::
          LoginRejectionReason.t()
          | {:invalid_username, LoginRejectionDetail.t()}
          | :registration_failed

  @spec login(String.t(), String.t()) :: {:ok, User.t()} | {:error, login_error()}
  def login(username, password) do
    with :ok <- validate_password(password),
         :ok <- validate_username(username) do
      find_or_register(username, password)
    end
  end

  defp validate_password(""), do: {:error, :empty_password}
  defp validate_password(_password), do: :ok

  defp validate_username(username) do
    UsernameValidator.validate(username)
    |> case do
      :ok -> :ok
      {:error, detail} -> {:error, {:invalid_username, detail}}
    end
  end

  defp find_or_register(username, password) do
    user =
      Repo.one(
        from(u in User,
          left_join: p in assoc(u, :privilege),
          where: u.username == ^username,
          preload: [privilege: p]
        )
      )

    case user do
      nil -> register(username, password)
      user -> verify(user, password)
    end
  end

  defp register(username, password) do
    %User{}
    |> User.changeset(%{username: username, password: password})
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        {:ok, user}

      # Race: two connections registered the same new username concurrently.
      # The loser here just falls through to a normal login against the winner's row.
      {:error, %Ecto.Changeset{errors: [username: {_, [_, constraint: :unique]}]}} ->
        find_or_register(username, password)

      {:error, changeset} ->
        Logger.error("registration failed for username=#{username}: #{inspect(changeset.errors)}")
        {:error, :registration_failed}
    end
  end

  defp verify(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  @spec supporter?(User.t()) :: boolean()
  def supporter?(%User{privilege: %Ecto.Association.NotLoaded{}} = user) do
    supporter?(Repo.preload(user, :privilege))
  end

  def supporter?(%User{privilege: nil}), do: false

  def supporter?(%User{privilege: %{expires_at: expires_at}}) do
    DateTime.compare(expires_at, DateTime.utc_now()) == :gt
  end

  @spec touch_last_login(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def touch_last_login(user) do
    user
    |> Ecto.Changeset.change(
      last_login_at:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
    )
    |> Repo.update()
  end
end
