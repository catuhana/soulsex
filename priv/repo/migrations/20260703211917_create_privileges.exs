defmodule Soulsex.Repo.Migrations.CreatePrivileges do
  use Ecto.Migration

  def change do
    create table(:privileges) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :expires_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:privileges, [:user_id])
  end
end
