defmodule GitActivityTracker.Activity.Commit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "commits" do
    field :sha, :string
    field :date, :date
    field :message, :string
    belongs_to :user, GitActivityTracker.Authors.User
    belongs_to :repository, GitActivityTracker.Activity.Repository
    belongs_to :release, GitActivityTracker.Activity.Release

    timestamps()
  end


  @doc false
  def changeset(commit, attrs) do
    commit
    |> cast(attrs, [:sha, :date, :message])
    |> validate_required([:sha, :date, :message])
    |> assoc_constraint(:user)
    |> assoc_constraint(:repository)
    |> unique_constraint(:sha)
  end
end
