defmodule Soulsex.Schema.User do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  typed_schema "users" do
    field :username, :string, null: false
    field :password_hash, :string, null: false, redact: true

    has_one :privilege, Soulsex.Schema.Privilege

    field :last_login_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password_hash])
    |> validate_required([:username, :password_hash])
    |> validate_length(:username, max: Soulsex.UsernameValidator.max_length())
    |> unique_constraint(:username)
  end
end
