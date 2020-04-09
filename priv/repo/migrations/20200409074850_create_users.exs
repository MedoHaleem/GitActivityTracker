defmodule GitActivityTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :email, :string
      add :uuid, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:uuid])
  end
end
