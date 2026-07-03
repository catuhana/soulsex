defmodule Soulsex.Schema.User do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  typed_schema "users" do
    field :username, :string, null: false

    field :password, :string, null: false, virtual: true, redact: true
    field :password_hash, :string, null: false, redact: true

    field :last_login_at, :utc_datetime

    has_one :privilege, Soulsex.Schema.Privilege

    timestamps(type: :utc_datetime)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    # TODO: Maybe have globals for things like this.
    |> validate_length(:username, max: 30)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ),
       do: put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

  defp put_password_hash(changeset), do: changeset
end
