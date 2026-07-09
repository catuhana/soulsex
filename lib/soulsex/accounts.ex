defmodule Soulsex.Accounts do
  @moduledoc false

  require Logger

  import Ecto.Query

  alias Soulseek.{LoginRejectionDetail, LoginRejectionReason}
  alias Soulsex.{Repo, UsernameValidator}
  alias Soulsex.Schema.User

  @repo Application.compile_env(:soulsex, :repo, Repo)
  @hasher Application.compile_env(:soulsex, :hasher, Argon2)
  @clock Application.compile_env(:soulsex, :clock, &DateTime.utc_now/0)

  @type login_error ::
          {:invalid_username, LoginRejectionDetail.t()}
          | {:rejected, LoginRejectionReason.t()}
          | {:registration_failed, Ecto.Changeset.t()}

  @spec login(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, login_error()}
  def login(username, password) do
    with :ok <- validate_password(password),
         :ok <- validate_username(username) do
      find_or_register(username, password)
    else
      {:error, {:invalid_username, detail}} -> {:error, {:invalid_username, detail}}
      {:error, reason} -> {:error, {:rejected, reason}}
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
      @repo.one(
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
    password_hash = @hasher.hash_pwd_salt(password)

    %User{}
    |> User.registration_changeset(%{username: username, password_hash: password_hash})
    |> @repo.insert()
    |> case do
      {:ok, user} ->
        {:ok, user}

      {:error, %Ecto.Changeset{errors: [username: {_, [_, constraint: :unique]}]}} ->
        find_or_register(username, password)

      {:error, changeset} ->
        Logger.error("registration failed for username=#{username}: #{inspect(changeset.errors)}")
        {:error, {:registration_failed, changeset}}
    end
  end

  defp verify(user, password) do
    if @hasher.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, {:rejected, :invalid_password}}
    end
  end

  @spec supporter?(User.t()) :: boolean()
  def supporter?(%User{privilege: %Ecto.Association.NotLoaded{}} = user) do
    supporter?(@repo.preload(user, :privilege))
  end

  def supporter?(%User{privilege: nil}), do: false

  def supporter?(%User{privilege: %{expires_at: expires_at}}, %{clock: clock}) do
    DateTime.compare(expires_at, clock.()) == :gt
  end

  @spec touch_last_login(User.t()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def touch_last_login(user) do
    user
    |> Ecto.Changeset.change(
      last_login_at:
        @clock.()
        |> DateTime.truncate(:second)
    )
    |> @repo.update()
  end
end
