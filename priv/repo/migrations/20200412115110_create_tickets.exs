defmodule GitActivityTracker.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :commit_id, references(:commits, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:tickets, [:commit_id])
  end
end
