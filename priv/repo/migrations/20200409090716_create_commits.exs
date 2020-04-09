defmodule GitActivityTracker.Repo.Migrations.CreateCommits do
  use Ecto.Migration

  def change do
    create table(:commits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sha, :string
      add :message, :string
      add :date, :date
      # I assume the app won't have the ability to delete users from database but for some reason
      # if it for GDPR we can use nilify_all to delete user data but keep the commits of the deleted user
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :repository_id, references(:repositories, on_delete: :delete_all, type: :binary_id)
      add :release_id, references(:releases, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:commits, [:sha])
    create index(:commits, [:user_id])
    create index(:commits, [:repository_id])
    create index(:commits, [:release_id])
    # commits are only released once
    create unique_index(:commits, [:release_id, :sha])
  end
end
