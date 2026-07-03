defmodule Soulsex.Schema.Privilege do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  alias Soulsex.Schema.User

  typed_schema "privileges" do
    belongs_to :user, User
    field :expires_at, :utc_datetime, null: false

    timestamps(type: :utc_datetime)
  end

  def changeset(privilege, params \\ %{}) do
    privilege
    |> cast(params, [:user_id, :expires_at])
    |> validate_required([:user_id, :expires_at])
  end
end
