defmodule GitActivityTracker.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :uuid, :integer
      add :name, :string

      timestamps()
    end

    create unique_index(:repositories, [:uuid])
  end
end
