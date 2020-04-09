defmodule GitActivityTracker.Repo.Migrations.CreateReleases do
  use Ecto.Migration

  def change do
    create table(:releases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :uuid, :integer
      add :tag_name, :string
      add :released_at, :date
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:releases, [:uuid])
    create index(:releases, [:user_id])
  end
end
